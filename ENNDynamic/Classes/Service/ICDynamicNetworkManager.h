//
//  ICMineNetworkManager.h
//  ICome
//
//  Created by zhangrongwu on 16/9/26.
//  Copyright © 2016年 iCom. All rights reserved.
//  每一个模块的http请求

#import "ICNetworkManager.h"

@interface ICDynamicNetworkManager : ICNetworkManager

+(instancetype)sharedInstance;

// 有缓存 动态列表
- (void)requestFindListWithParam:(NSDictionary *)param
                    requestCache:(RequestCache)requestCache
                         Success:(void (^)(BOOL isSuccess, NSArray *findList))success
                         failure:(HttpFailureCompletionHandle)failure;
// 无缓存 动态列表
- (void)requestASCFindListWithParam:(NSDictionary *)param
                            Success:(void (^)(BOOL isSuccess, NSArray *findList))success
                            failure:(HttpFailureCompletionHandle)failure;

// 下拉增量刷新
- (void)requestASCFindListWithParam:(NSDictionary *)param
                       requestCache:(RequestCache)requestCache
                            Success:(void (^)(BOOL isSuccess, NSArray *findList))success
                            failure:(HttpFailureCompletionHandle)failure;
// 我的动态列表
- (void)requestMyFindListWithParam:(NSDictionary *)param
                           Success:(void (^)(BOOL isSuccess, NSArray *findList))success
                           failure:(HttpFailureCompletionHandle)failure;
// 下拉我的动态
- (void)requestMyFindListASCWithParam:(NSDictionary *)param
                              Success:(void (^)(BOOL isSuccess, NSArray *findList))success
                              failure:(HttpFailureCompletionHandle)failure;
// 发布动态
- (void)requestAddFindWithParam:(NSDictionary *)param
                        success:(HttpSuccessCompletionHandle)success
                        failure:(HttpFailureCompletionHandle)failure;
// 删除动态
- (void)deleteUserDyncWithParam:(NSDictionary *)param
                        success:(HttpSuccessCompletionHandle)success
                        failure:(HttpFailureCompletionHandle)failure;
// 点赞／取消点赞
- (void)requestPraiseWithParam:(NSDictionary *)param
                       success:(HttpSuccessCompletionHandle)success
                       failure:(HttpFailureCompletionHandle)failure;
// 添加评论
- (void)addFindCommentWithParam:(NSDictionary *)param
                        success:(HttpSuccessCompletionHandle)success
                        failure:(HttpFailureCompletionHandle)failure;
// 删除评论
- (void)deleteFindCommentWithParam:(NSDictionary *)param
                           success:(HttpSuccessCompletionHandle)success
                           failure:(HttpFailureCompletionHandle)failure;

// 收藏
- (void)addFavoriteWithParam:(NSDictionary *)param
                     Success:(HttpSuccessCompletionHandle)success
                     failure:(HttpFailureCompletionHandle)failure;

@end
