//
//  ICMineNetworkManager.m
//  ICome
//
//  Created by zhangrongwu on 16/9/26.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICDynamicNetworkManager.h"
#import "ICDiscoverModel.h"

#define DYNAMIC_FINDLIST      @"discovery/findList"  //动态列表
#define DYNAMIC_FINDLISTASC   @"discovery/findListASC" // 下拉数据增量添加
#define DYNAMIC_MYFINDLIST    @"discovery/myFindList" // 我的动态
#define DYNAMIC_MYFINDLISTASC @"discovery/myFindList"
#define DYNAMIC_DELFIND       @"discovery/delFind" // 删除动态
#define DYNAMIC_PRAISE        @"discovery/findPraise" //动态的点赞或取消点赞
#define DYNAMIC_FINDCOMMENT   @"discovery/addFindComment" // 发评论
#define DYNAMIC_DELCOMMENT    @"discovery/delFindComment" //删除动态评论
#define DYNAMIC_ADDFIND       @"discovery/addFind" // 发布动态
#define MINE_ADD_FAVORITE      @"licensor/addFavorite" // 添加收藏


@implementation ICDynamicNetworkManager

+(instancetype)sharedInstance {
    static ICDynamicNetworkManager *manager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[ICDynamicNetworkManager alloc] init];
    });
    return manager;
}

- (void)requestFindListWithParam:(NSDictionary *)param
                    requestCache:(RequestCache)requestCache
                         Success:(void (^)(BOOL isSuccess, NSArray *findList))success
                         failure:(HttpFailureCompletionHandle)failure {
    NSString *url = [self appendRequestBaseURL:DYNAMIC_FINDLIST];
    
    [ICNetworkHelper POST:url parameters:param responseCache:^(id responseCache) {
        NSMutableArray *layoutList = [[NSMutableArray alloc] init];
        [layoutList addObjectsFromArray:[self findDataListWithDict:responseCache]];
        requestCache(layoutList);
    } success:^(id responseObject) {
        NSMutableArray *layoutList = [[NSMutableArray alloc] init];
        [layoutList addObjectsFromArray:[self findDataListWithDict:responseObject]];
        success(YES, layoutList);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)requestASCFindListWithParam:(NSDictionary *)param
                       requestCache:(RequestCache)requestCache
                            Success:(void (^)(BOOL isSuccess, NSArray *findList))success
                            failure:(HttpFailureCompletionHandle)failure {
    NSString *url = [self appendRequestBaseURL:DYNAMIC_FINDLISTASC];
    [ICNetworkHelper POST:url parameters:param responseCache:^(id responseCache) {
        NSMutableArray *layoutList = [[NSMutableArray alloc] init];
        [layoutList addObjectsFromArray:[self findDataListWithDict:responseCache]];
        success(YES, layoutList);
    } success:^(id responseObject) {
        NSMutableArray *layoutList = [[NSMutableArray alloc] init];
        [layoutList addObjectsFromArray:[self findDataListWithDict:responseObject]];
        if (layoutList.count >0) {
            success(YES, layoutList);
        } else {
            success(NO, nil);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)requestASCFindListWithParam:(NSDictionary *)param
                            Success:(void (^)(BOOL isSuccess, NSArray *findList))success
                            failure:(HttpFailureCompletionHandle)failure {
    NSString *url = [self appendRequestBaseURL:DYNAMIC_FINDLISTASC];
    [ICNetworkHelper POST:url parameters:param success:^(id responseObject) {
        NSMutableArray *layoutList = [[NSMutableArray alloc] init];
        [layoutList addObjectsFromArray:[self findDataListWithDict:responseObject]];
        success(YES, layoutList);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


- (void)requestMyFindListWithParam:(NSDictionary *)param
                           Success:(void (^)(BOOL isSuccess, NSArray *findList))success
                           failure:(HttpFailureCompletionHandle)failure {
    NSString *url = [self appendRequestBaseURL:DYNAMIC_MYFINDLIST];
    [ICNetworkHelper POST:url parameters:param success:^(id responseObject) {
        NSMutableArray *layoutList = [[NSMutableArray alloc] init];
        [layoutList addObjectsFromArray:[self findDataListWithDict:responseObject]];
        success(YES, layoutList);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)requestMyFindListASCWithParam:(NSDictionary *)param
                              Success:(void (^)(BOOL isSuccess, NSArray *findList))success
                              failure:(HttpFailureCompletionHandle)failure {
    NSString *url = [self appendRequestBaseURL:DYNAMIC_MYFINDLISTASC];
    [ICNetworkHelper POST:url parameters:param success:^(id responseObject) {
        NSMutableArray *layoutList = [[NSMutableArray alloc] init];
        [layoutList addObjectsFromArray:[self findDataListWithDict:responseObject]];
        success(YES, layoutList);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}


- (NSMutableArray *)findDataListWithDict:(NSDictionary *)dict {
    NSMutableArray *layoutList = [[NSMutableArray alloc] init];
    NSArray *findArray  = [dict objectForKey:@"data"];
    for (NSDictionary *dict in findArray) {
        ICDiscoverModel *model = [ICDiscoverModel mj_objectWithKeyValues:dict];
        model.contentallCount = 7;
        [model setCreatDateHidden]; // 个人动态需隐藏日期处理
        [layoutList addObject:model];
    }
    return layoutList;
}


- (void)requestAddFindWithParam:(NSDictionary *)param
                        success:(HttpSuccessCompletionHandle)success
                        failure:(HttpFailureCompletionHandle)failure {
    NSString *url = [self appendRequestBaseURL:DYNAMIC_ADDFIND];
    [ICNetworkHelper POST:url parameters:param success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)deleteUserDyncWithParam:(NSDictionary *)param
                        success:(HttpSuccessCompletionHandle)success
                        failure:(HttpFailureCompletionHandle)failure {
    NSString *url = [self appendRequestBaseURL:DYNAMIC_DELFIND];
    [ICNetworkHelper POST:url parameters:param success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)requestPraiseWithParam:(NSDictionary *)param
                       success:(HttpSuccessCompletionHandle)success
                       failure:(HttpFailureCompletionHandle)failure {
    NSString *url = [self appendRequestBaseURL:DYNAMIC_PRAISE];
    [ICNetworkHelper POST:url parameters:param success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)addFindCommentWithParam:(NSDictionary *)param
                        success:(HttpSuccessCompletionHandle)success
                        failure:(HttpFailureCompletionHandle)failure {
    NSString *url = [self appendRequestBaseURL:DYNAMIC_FINDCOMMENT];
    [ICNetworkHelper POST:url parameters:param success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)deleteFindCommentWithParam:(NSDictionary *)param
                           success:(HttpSuccessCompletionHandle)success
                           failure:(HttpFailureCompletionHandle)failure {
    NSString *url = [self appendRequestBaseURL:DYNAMIC_DELCOMMENT];
    [ICNetworkHelper POST:url parameters:param success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

// 收藏
- (void)addFavoriteWithParam:(NSDictionary *)param
                     Success:(HttpSuccessCompletionHandle)success
                     failure:(HttpFailureCompletionHandle)failure {
    NSString *url = [self appendRequestBaseURL:MINE_ADD_FAVORITE];
    
    [ICNetworkHelper POST:url parameters:param success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
