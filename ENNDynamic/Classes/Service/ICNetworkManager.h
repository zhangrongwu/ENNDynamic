//
//  ICDynamicNetworkManager.h
//  ICome
//
//  Created by zhang_rongwu on 16/3/4.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICNetworkHelper.h"

typedef void(^HttpSuccessCompletionHandle)(id object);
typedef void(^HttpFailureCompletionHandle)(NSError *error);
typedef void(^Progress)(NSProgress *pro);
typedef void (^RequestCache)(id responseCache);

typedef void (^OtherSuccess)(id object,NSString *key);
typedef void (^OtherFailure)(NSError *error,NSString *key);


@interface ICNetworkManager : NSObject

+(instancetype)sharedInstance;

// base api
- (NSString *) appendRequestBaseURL:(NSString *)path;

// 发送语音或视频
- (void)sendMedia:(NSData *)MediaData
        mediaName:(NSString *)mediaName
          success:(HttpSuccessCompletionHandle)success
          failure:(HttpFailureCompletionHandle)failure;

// 获取语音
- (void)getMedia:(NSString *)fileKey
         success:(HttpSuccessCompletionHandle)success
         failure:(HttpFailureCompletionHandle)failure;
// chat 获取视频 －
- (void)getVideo:(NSString *)fileKey
        progress:(Progress)progress
         success:(HttpSuccessCompletionHandle)success
         failure:(HttpFailureCompletionHandle)failure;

// 音频下载
- (void)downloadRecod:(NSString *)fileKey
              fileDir:(NSString *)fileDir
             progress:(Progress)mediaProgress
              success:(HttpSuccessCompletionHandle)success
              failure:(HttpFailureCompletionHandle)failure;

/** new download Media video、audio 等  */
- (void)downloadMedia:(NSString *)fileKey
              fileDir:(NSString *)fileDir
             progress:(Progress)mediaProgress
              success:(HttpSuccessCompletionHandle)success
              failure:(HttpFailureCompletionHandle)failure;

// 文件
- (void)getFile:(NSString *)fileKey
       progress:(Progress)progress
        success:(HttpSuccessCompletionHandle)success
        failure:(HttpFailureCompletionHandle)failure;

// 发送文件
- (void)sendFile:(NSData *)fileData
        fileName:(NSString *)fileName
        progress:(void(^)(NSProgress *))fileProgress
         success:(HttpSuccessCompletionHandle)success
         failure:(HttpFailureCompletionHandle)failure;

// check fileKey
- (void)checkFileKey:(NSString *)fileKey
             success:(HttpSuccessCompletionHandle)success
             failure:(HttpFailureCompletionHandle)failure;
// 更新头像
- (void)updateEmpImage:(NSData *)imgData
                 param:(NSDictionary *)param
               success:(HttpSuccessCompletionHandle)success
               failure:(HttpFailureCompletionHandle)failure;
// 跟新群组头像
- (void)updateGroupImage:(NSData *)imgData
                   param:(NSDictionary *)param
                 success:(HttpSuccessCompletionHandle)success
                 failure:(HttpFailureCompletionHandle)failure;

- (void)getMaxImage:(NSString *)fileKey
            success:(HttpSuccessCompletionHandle)success
            failure:(HttpFailureCompletionHandle)failure;

// 发送图片 进度条
- (void)sendImage:(NSData *)imgData
          imgName:(NSString *)imgName
         progress:(void(^)(NSProgress *pro))progress
          success:(HttpSuccessCompletionHandle)success
          failure:(HttpFailureCompletionHandle)failure;


@end
