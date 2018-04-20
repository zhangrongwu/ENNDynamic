//
//  ICNetworkManager.m
//  ICome
//
//  Created by zhang_rongwu on 16/3/4.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICNetworkManager.h"

@interface ICNetworkManager ()

@end

@implementation ICNetworkManager

+(instancetype)sharedInstance {
    static dispatch_once_t once;
    static ICNetworkManager *manager;
    dispatch_once(&once, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
-(void)setNetworkHelper {
    [ICNetworkHelper setValue:TOKEN forHTTPHeaderField:@"token"];
    [ICNetworkHelper setValue:JSTICKET forHTTPHeaderField:@"auth"];
    [ICNetworkHelper setSecurityPolicy:[ICNetworkManager customSecurityPolicy]];
    [ICNetworkHelper setRequestTimeoutInterval:50.f];
}

- (instancetype)init {
    if (self = [super init]) {
        [self setNetworkHelper];
    }
    return self;
}

// https 处理
+ (AFSecurityPolicy*)customSecurityPolicy {
    // 证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = NO;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    securityPolicy.pinnedCertificates = [NSSet setWithObjects:certData, nil];
    return securityPolicy;
}

/** 拼接BASEURL*/
- (NSString *) appendRequestBaseURL:(NSString *)path{
    return [NSString stringWithFormat:@"%@%@",BASEURL,path];
}

// 发送图片 进度条
- (void)sendImage:(NSData *)imgData
          imgName:(NSString *)imgName
         progress:(void(^)(NSProgress *pro))progress
          success:(HttpSuccessCompletionHandle)success
          failure:(HttpFailureCompletionHandle)failure
{
    NSString *url = [self appendRequestBaseURL:@"fileserver/image/sendImage"];
    NSDictionary *parameters = @{@"fileName" : imgName};
    [ICNetworkHelper uploadWithURL:url parameters:parameters data:imgData name:@"file" fileName:imgName mimeType:@"image/png" progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

// 发送语音
- (void)sendMedia:(NSData *)MediaData
        mediaName:(NSString *)mediaName
          success:(HttpSuccessCompletionHandle)success
          failure:(HttpFailureCompletionHandle)failure
{
    NSString *url = [self appendRequestBaseURL:@"fileserver/media/sendMedia"];
    NSDictionary *parameters = @{
                                 @"fileName" : mediaName,
                                 };
    [ICNetworkHelper uploadWithURL:url parameters:parameters data:MediaData name:@"file" fileName:mediaName mimeType:@"audio/mpeg" progress:^(NSProgress *progress) {
    } success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

// 获取语音
- (void)getMedia:(NSString *)fileKey
         success:(HttpSuccessCompletionHandle)success
         failure:(HttpFailureCompletionHandle)failure
{
    NSDictionary *parameter = @{
                                @"fileKey" : fileKey
                                };
    NSString *url = [self appendRequestBaseURL:@"fileserver/media/getMedia"];
    [ICNetworkHelper GETFile:url parameters:parameter progress:^(NSProgress *pro) {
    } success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

// 获取视频 －
- (void)getVideo:(NSString *)fileKey
        progress:(Progress)progress
         success:(HttpSuccessCompletionHandle)success
         failure:(HttpFailureCompletionHandle)failure

{
    [self downloadMedia:fileKey fileDir:kDiscvoerVideoPath progress:^(NSProgress *pro) {
        progress(pro);
    } success:^(id object) {
        success(object);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
// 音频下载
- (void)downloadRecod:(NSString *)fileKey
              fileDir:(NSString *)fileDir
             progress:(Progress)mediaProgress
              success:(HttpSuccessCompletionHandle)success
              failure:(HttpFailureCompletionHandle)failure {
    
    NSString *url = [NSString stringWithFormat:@"%@?fileKey=%@&token=%@", [self appendRequestBaseURL:@"fileserver/media/getMedia"], fileKey,TOKEN];
    [ICNetworkHelper downloadWithURL:url fileDir:fileDir fileName:[NSString stringWithFormat:@"%@%@", fileKey,kRecodAmrType] progress:^(NSProgress *progress) {
        mediaProgress(progress);
    } success:^(NSString *filePath) {
        success(filePath);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)downloadMedia:(NSString *)fileKey
              fileDir:(NSString *)fileDir
             progress:(Progress)mediaProgress
              success:(HttpSuccessCompletionHandle)success
              failure:(HttpFailureCompletionHandle)failure {
    
    NSString *url = [NSString stringWithFormat:@"%@?fileKey=%@&token=%@", [self appendRequestBaseURL:@"fileserver/media/getMedia"], fileKey,TOKEN];
    [ICNetworkHelper downloadWithURL:url fileDir:fileDir fileName:[NSString stringWithFormat:@"%@%@", fileKey,kVideoType] progress:^(NSProgress *progress) {
        mediaProgress(progress);
    } success:^(NSString *filePath) {
        success(filePath);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (void)getFile:(NSString *)fileKey
       progress:(Progress)progress
        success:(HttpSuccessCompletionHandle)success
        failure:(HttpFailureCompletionHandle)failure
{
    NSDictionary *parameter = @{
                                @"fileKey" : fileKey
                                };
    NSString *url = [self appendRequestBaseURL:@"fileserver/file/getFile"];
    [ICNetworkHelper GETFile:url parameters:parameter progress:^(NSProgress *pro) {
     if (progress) progress(pro);
    } success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

// 发送文件
- (void)sendFile:(NSData *)fileData
        fileName:(NSString *)fileName
        progress:(void(^)(NSProgress *))fileProgress
         success:(HttpSuccessCompletionHandle)success
         failure:(HttpFailureCompletionHandle)failure
{
    NSString *url = [self appendRequestBaseURL:@"fileserver/file/sendFile"];
    NSDictionary *parameters = @{@"fileName" : fileName};
    [ICNetworkHelper uploadWithURL:url parameters:parameters data:fileData name:@"file" fileName:fileName mimeType:@"audio/mpeg" progress:^(NSProgress *progress) {
        fileProgress(progress);
    } success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


// check fileKey
- (void)checkFileKey:(NSString *)fileKey
             success:(HttpSuccessCompletionHandle)success
             failure:(HttpFailureCompletionHandle)failure
{
    NSString *url = [self appendRequestBaseURL:@"fileserver/file/checkFileKey"];
    NSDictionary *parameters = @{
                                 @"fileKey" : fileKey,
                                 };
    [ICNetworkHelper GET:url parameters:parameters success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


- (void)getMaxImage:(NSString *)fileKey
            success:(HttpSuccessCompletionHandle)success
            failure:(HttpFailureCompletionHandle)failure
{
    NSDictionary *parameter = @{
                                @"fileKey" : fileKey
                                };
    NSString *url = [self appendRequestBaseURL:@"fileserver/image/getMax"];
    
    [ICNetworkHelper GETFile:url parameters:parameter progress:^(NSProgress *pro) {
    } success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

// 更新头像
- (void)updateEmpImage:(NSData *)imgData
                 param:(NSDictionary *)param
               success:(HttpSuccessCompletionHandle)success
               failure:(HttpFailureCompletionHandle)failure
{
    NSString *url = [self appendRequestBaseURL:@"fileserver/photo/sendEmployeePhoto"];
    [ICNetworkHelper uploadWithURL:url parameters:param data:imgData name:@"file" fileName:param[@"fileName"] mimeType:@"image/png" progress:^(NSProgress *progress) {
    } success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}
// 上传群组头像
- (void)updateGroupImage:(NSData *)imgData
                   param:(NSDictionary *)param
                 success:(HttpSuccessCompletionHandle)success
                 failure:(HttpFailureCompletionHandle)failure
{
    NSString *url = [self appendRequestBaseURL:@"fileserver/photo/sendGroupPhoto"];
    [ICNetworkHelper uploadWithURL:url parameters:param data:imgData name:@"file" fileName:param[@"fileName"] mimeType:@"image/png" progress:^(NSProgress *progress) {
    } success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
