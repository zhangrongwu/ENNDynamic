//
//  ICDiscoverDataController.m
//  ICome
//
//  Created by zhangrongwu on 16/6/17.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICDiscoverDataController.h"
#import "ICPraiseModel.h"
#import "ICCommentModel.h"
#import "ICVideoManager.h"
#import "MBProgressHUD+Tool.h"
#import "ICDynamicNetworkManager.h"

@implementation ICDiscoverDataController
- (void)requestFindListWithParam:(nullable NSDictionary *)dict
                    FinishHandle:(nullable MessageHandle)finishHandle
                        Callback:(nullable ICCompletionCallback)callback {
    [[ICDynamicNetworkManager sharedInstance] requestFindListWithParam:dict requestCache:^(id responseCache) {
        
    }  Success:^(BOOL isSuccess, NSArray *findList) {
        if (isSuccess) {
            [self.subjects addObjectsFromArray:findList];
            if (callback) {
                callback(nil);
            }
            
            if (findList.count == 0) {
                [MBProgressHUD showError:@"内容已全部加载"];
                if (finishHandle) {
                    finishHandle(findList);
                }
            }
        } else {
            NSError *err;
            if (callback) {
                callback(err);
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"请求失败"];
        if (callback) {
            callback(error);
        }
    }];
}

- (void)requestASCFindListWithParam:(NSDictionary *)dict
                           Callback:(ICCompletionCallback)callback {
    [[ICDynamicNetworkManager sharedInstance] requestASCFindListWithParam:dict requestCache:^(id responseCache) {
        [self.subjects removeAllObjects];
        [self.subjects insertObjects:responseCache atIndex:0];
        callback(nil);
    } Success:^(BOOL isSuccess, NSArray *findList) {
        if (isSuccess) {
            [self.subjects removeAllObjects];
            [self.subjects insertObjects:findList atIndex:0];
            if (callback) {
                callback(nil);
            }
        } else {
            NSError *err;
            if (callback) {
                callback(err);
            }
        }
    } failure:^(NSError *error) {
        if (callback) {
            callback(error);
        }
    }];
}

// 进行点赞
- (void)requestPraiseWithFindId:(nullable NSString *)findId
                     indexPatch:(nullable NSIndexPath *)indexPatch
                       Callback:(nullable ICCompletionCallback)callback {
    NSDictionary *param = @{@"eId":[ICUser currentUser].eId,
                            @"findId":findId};
    [[ICDynamicNetworkManager sharedInstance] requestPraiseWithParam:param success:^(id object) {
        if (object) {
            ICDiscoverModel *model = [self.subjects objectAtIndex:indexPatch.row];
            NSInteger Status = [[object objectForKey:@"data"] integerValue];
            if (Status == 0) {// 取消
                [model.praiseList enumerateObjectsUsingBlock:^(ICPraiseModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.eId isEqualToString:[ICUser currentUser].eId]) {
                        [model.praiseList removeObject:obj];
                    }
                }];
            } else if (Status == 1) {// 点赞
                ICPraiseModel *praise = [[ICPraiseModel alloc] init];
                praise.eId    = [ICUser currentUser].eId;
                praise.eName  = [ICUser currentUser].eName;
                praise.findId = findId;
                [model.praiseList addObject:praise];
            }
            if (callback) {
                callback(nil);
            }
        } else {
            NSError *err;
            if (callback) {
                callback(err);
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"点赞失败"];
    }];
}

// 添加评论
- (void)requestaddCommentWithFindId:(nullable NSString *)findId
                            Comment:(NSString *)comment
                               toId:(NSString *)toId
                             toName:(NSString *)toName
                         indexPatch:(nullable NSIndexPath *)indexPatch
                           Callback:(nullable ICCompletionCallback)callback {
    NSDictionary *param = @{@"findId":findId,
                            @"eId":[ICUser currentUser].eId,
                            @"eName":[ICUser currentUser].eName,
                            @"tId":toId,
                            @"tName":toName,
                            @"comment":comment};
    [[ICDynamicNetworkManager sharedInstance] addFindCommentWithParam:param success:^(id object) {
        if (object) {
            ICDiscoverModel *model = [self.subjects objectAtIndex:indexPatch.row];
            NSString *key = [[object objectForKey:@"data"] objectForKey:@"findCommentId"];
            ICCommentModel *CommentModel = [[ICCommentModel alloc] init];
            CommentModel.eId = [ICUser currentUser].eId;
            CommentModel.eName = [ICUser currentUser].eName;
            CommentModel.findCommentId = key;
            CommentModel.tId = toId;
            CommentModel.tName = toName;
            CommentModel.comment = comment;
            [model.commentList addObject:CommentModel];
            model.commentCount++;
            if (callback) {
                callback(nil);
            }
        } else {
            NSError *err;
            if (callback) {
                callback(err);
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"评论失败"];
    }];
}

- (void)deleteDiscoverFindId:(nullable NSString *)findId
                  indexPatch:(nullable NSIndexPath *)indexPatch
                    Callback:(nullable ICCompletionCallback)callback {
    NSDictionary *param = @{@"eId":[ICUser currentUser].eId,
                            @"findId":findId};
    [[ICDynamicNetworkManager sharedInstance] deleteUserDyncWithParam:param success:^(id object) {
        if (object) {
            if (callback) {
                callback(nil);
            }
        } else {
            NSError *err;
            if (callback) {
                callback (err);
            }
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"删除失败"];
    }];
}
//// 删除评论
- (void)deleteDiscoverCommentFindId:(nullable NSString *)findId
                          CommentId:(nullable NSString *)commentId
                         indexPatch:(nullable NSIndexPath *)indexPatch
                           Callback:(nullable ICCompletionCallback)callback {
    NSDictionary *param = @{@"findId":findId,
                            @"eId":[ICUser currentUser].eId,
                            @"findCommentId":commentId};
    [[ICDynamicNetworkManager sharedInstance] deleteFindCommentWithParam:param success:^(id object) {
        ICDiscoverModel *model = [self.subjects objectAtIndex:indexPatch.row];
        [model.commentList enumerateObjectsUsingBlock:^(ICCommentModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.findCommentId isEqualToString:commentId]) {
                [model.commentList removeObject:obj];
                model.commentCount--;
            }
        }];
        if (callback) {
            callback(nil);
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"删除评论失败"];
    }];
}

- (void)downloadVideo:(nullable NSString *)fileKey
           indexPatch:(nullable NSIndexPath *)indexPatch
             progress:(nullable Progress)progress
             Callback:(nullable ICCompletionCallback)callback {
    NSString *path = [[ICVideoManager shareManager] videoPathWithFileName:fileKey fileDir:kDiscvoerVideoPath];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (!data && ![ICTools stringEmpty:fileKey]) { // 本地没数据 进行网络请求
        [[ICNetworkManager sharedInstance] downloadMedia:fileKey fileDir:kDiscvoerVideoPath progress:^(NSProgress *pro) {
            progress(pro);
        } success:^(id object) {
            if (object) {
                ICDiscoverModel *model = [self.subjects objectAtIndex:indexPatch.row];
                model.locVideoPath = path;
                if (callback) {
                    callback(nil);
                }
            } else {
                NSError *error;
                if (callback) {
                    callback(error);
                }
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"下载失败"];
        }];
    } else {
        if (callback) {
            callback(nil);
        }
    }
}

- (void)addFavoriteWithType:(nullable NSString *)type
                        eId:(nullable NSString *)eId
                        gId:(nullable NSString *)gId
                    photoId:(nullable NSString *)photoId
                      title:(nullable NSString *)title
                        txt:(nullable NSString *)txt
                        key:(nullable NSString *)key
                        lnk:(nullable NSString *)lnk
                      msgId:(nullable NSString *)msgId
                   Callback:(nullable ICCompletionCallback)callback {
    
    NSDictionary *param = @{@"eId":eId,
                            @"gId":gId,
                            @"photoId":photoId == nil ? @"" :photoId,
                            @"title":title,
                            @"txt":txt == nil ? @"" : txt,
                            @"type":type,
                            @"key":key == nil ? @"" : key,
                            @"lnk":lnk == nil ? @"" : lnk,
                            @"msgId":msgId
                            };

    [[ICDynamicNetworkManager sharedInstance] addFavoriteWithParam:param Success:^(id object) {
        if (callback) {
            callback(nil);
        }
    } failure:^(NSError *error) {
        if (callback) {
            callback(error);
        }
    }];
}



-(NSMutableArray<ICDiscoverModel *> *)subjects {
    if (!_subjects) {
        _subjects = [[NSMutableArray alloc] init];
    }
    return _subjects;
}

@end
