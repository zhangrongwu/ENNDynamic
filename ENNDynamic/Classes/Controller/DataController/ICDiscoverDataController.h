//
//  ICDiscoverDataController.h
//  ICome
//
//  Created by zhangrongwu on 16/6/17.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICBaseDataController.h"
#import "ICDiscoverModel.h"
#import "EnnDynamicHeader.h"
@interface ICDiscoverDataController : ICBaseDataController
@property (nonatomic, strong, nullable) NSMutableArray<ICDiscoverModel *> *subjects;

- (void)requestFindListWithParam:(nullable NSDictionary *)dict
                    FinishHandle:(nullable MessageHandle)finishHandle
                        Callback:(nullable ICCompletionCallback)callback;

- (void)requestASCFindListWithParam:(nullable NSDictionary *)dict
                           Callback:(nullable ICCompletionCallback)callback;

- (void)requestPraiseWithFindId:(nullable NSString *)findId
                     indexPatch:(nullable NSIndexPath *)indexPatch
                       Callback:(nullable ICCompletionCallback)callback;
- (void)requestaddCommentWithFindId:(nullable NSString *)findId
                            Comment:(nullable NSString *)comment
                               toId:(nullable NSString *)toId
                             toName:(nullable NSString *)toName
                         indexPatch:(nullable NSIndexPath *)indexPatch
                           Callback:(nullable ICCompletionCallback)callback;
- (void)deleteDiscoverFindId:(nullable NSString *)findId
                  indexPatch:(nullable NSIndexPath *)indexPatch
                    Callback:(nullable ICCompletionCallback)callback;
- (void)deleteDiscoverCommentFindId:(nullable NSString *)findId
                          CommentId:(nullable NSString *)commentId
                         indexPatch:(nullable NSIndexPath *)indexPatch
                           Callback:(nullable ICCompletionCallback)callback;
- (void)downloadVideo:(nullable NSString *)fileKey
           indexPatch:(nullable NSIndexPath *)indexPatch
             progress:(nullable Progress)progress
             Callback:(nullable ICCompletionCallback)callback;

- (void)addFavoriteWithType:(nullable NSString *)type
                        eId:(nullable NSString *)eId
                        gId:(nullable NSString *)gId
                    photoId:(nullable NSString *)photoId
                      title:(nullable NSString *)title
                        txt:(nullable NSString *)txt
                        key:(nullable NSString *)key
                        lnk:(nullable NSString *)lnk
                      msgId:(nullable NSString *)msgId
                   Callback:(nullable ICCompletionCallback)callback;


@end
