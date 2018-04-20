//
//  ICNetworkHelper.m
//  ICome
//
//  Created by zhangrongwu on 16/9/14.
//  Copyright © 2016年 iCom. All rights reserved.
//

#import "ICNetworkHelper.h"
#import "ICNetworkCache.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation ICNetworkHelper

static AFHTTPSessionManager *_manager;
static AFHTTPSessionManager *_fileManager;

#pragma GET - NO Cache
+(__kindof NSURLSessionTask *)GET:(NSString *)URL
                       parameters:(NSDictionary *)parameters
                          success:(HttpRequestSuccess)success
                          failure:(HttpRequestFailed)failure {
    return [self GET:URL parameters:parameters responseCache:nil success:success failure:failure];
}


#pragma POST - NO Cache
+(__kindof NSURLSessionTask *)POST:(NSString *)URL
                        parameters:(NSDictionary *)parameters
                           success:(HttpRequestSuccess)success
                           failure:(HttpRequestFailed)failure {
    return [self POST:URL parameters:parameters responseCache:nil success:success failure:failure];
}

#pragma GET - YES Cache
+ (__kindof NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(NSDictionary *)parameters
                     responseCache:(HttpRequestCache)responseCache
                           success:(HttpRequestSuccess)success
                           failure:(HttpRequestFailed)failure {
    responseCache ? responseCache([ICNetworkCache getHttpCacheForKey:URL]) : nil;
    return [_manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"errno"] integerValue] == 0) {
            success ? success(responseObject) : nil;
            //对数据进行异步缓存
            responseCache ? [ICNetworkCache saveHttpCache:responseObject forKey:URL] : nil;
        } else {
            NSError *error = [NSError errorWithDomain:[responseObject objectForKey:@"error"] code:[[responseObject objectForKey:@"errno"] intValue] userInfo:nil];
            failure ? failure(error) : nil;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *userInfo = error.userInfo;
        NSString *localizedDescription = userInfo[NSLocalizedDescriptionKey];
        if (![ICTools stringEmpty:localizedDescription]) {
            NSError *newError = [NSError errorWithDomain:localizedDescription code:error.code userInfo:nil];
            failure ? failure(newError) : nil;
        } else {
            NSError *newError = [NSError errorWithDomain:@"网络异常" code:0 userInfo:nil];
            failure ? failure(newError) : nil;
        }
    }];
}

#pragma POST - YES Cache
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                      responseCache:(HttpRequestCache)responseCache
                            success:(HttpRequestSuccess)success
                            failure:(HttpRequestFailed)failure {
    responseCache ? responseCache([ICNetworkCache getHttpCacheForKey:URL]) : nil;
    return [_manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"errno"] integerValue] == 0) {
            success ? success(responseObject) : nil;
            //对数据进行异步缓存
            responseCache ? [ICNetworkCache saveHttpCache:responseObject forKey:URL] : nil;
        } else {
            NSError *error = [NSError errorWithDomain:[responseObject objectForKey:@"error"] code:[[responseObject objectForKey:@"errno"] intValue] userInfo:nil];
            failure ? failure(error) : nil;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *userInfo = error.userInfo;
        NSString *localizedDescription = userInfo[NSLocalizedDescriptionKey];
        if (![ICTools stringEmpty:localizedDescription]) {
            NSError *newError = [NSError errorWithDomain:localizedDescription code:error.code userInfo:nil];
            failure ? failure(newError) : nil;
        } else {
            NSError *newError = [NSError errorWithDomain:@"网络异常" code:0 userInfo:nil];
            failure ? failure(newError) : nil;
        }
    }];
}

#pragma upLoad - file
+ (__kindof NSURLSessionTask *)uploadWithURL:(NSString *)URL
                                  parameters:(NSDictionary *)parameters
                                        data:(NSData *)data
                                        name:(NSString *)name
                                    fileName:(NSString *)fileName
                                    mimeType:(NSString *)mimeType
                                    progress:(HttpProgress)progress
                                     success:(HttpRequestSuccess)success
                                     failure:(HttpRequestFailed)failure {
    return [_manager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:name ? name : @"file" fileName:fileName mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        progress ? progress(uploadProgress) : nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[responseObject objectForKey:@"errno"] integerValue] == 0) {
            success ? success(responseObject) : nil;
        } else {
            NSError *error = [NSError errorWithDomain:[responseObject objectForKey:@"error"] code:0 userInfo:nil];
            failure ? failure(error) : nil;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *userInfo = error.userInfo;
        NSString *localizedDescription = userInfo[NSLocalizedDescriptionKey];
        if (![ICTools stringEmpty:localizedDescription]) {
            NSError *newError = [NSError errorWithDomain:localizedDescription code:error.code userInfo:nil];
            failure ? failure(newError) : nil;
        } else {
            NSError *newError = [NSError errorWithDomain:@"网络异常" code:0 userInfo:nil];
            failure ? failure(newError) : nil;
        }
    }];
}

#pragma downLoad - file
+ (__kindof NSURLSessionTask *)downloadWithURL:(NSString *)URL
                                       fileDir:(NSString *)fileDir
                                      fileName:(NSString *)fileName
                                      progress:(HttpProgress)progress
                                       success:(void(^)(NSString *filePath))success
                                       failure:(HttpRequestFailed)failure {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    
    NSURLSessionDownloadTask *downloadTask = [_fileManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        progress ? progress(downloadProgress) : nil;
//        NSLog(@"下载进度:%.2f%%",100.0*downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:fileName ? fileName : response.suggestedFilename];
        
//        NSLog(@"downloadDir = %@, filePath = %@",downloadDir, filePath);
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if(failure && error) {failure(error) ; return ;};
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
    }];
    
    [downloadTask resume];
    
    return downloadTask;
}
#pragma downLoad - file
+ (__kindof NSURLSessionTask *)GETFile:(NSString *)URL
                            parameters:(NSDictionary *)parameters
                              progress:(void(^)(NSProgress *pro))progress
                               success:(HttpRequestSuccess)success
                               failure:(HttpRequestFailed)failure {
    _fileManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    return [_fileManager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        progress ? progress(downloadProgress) : nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success ? success(responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
}




















#pragma mark - 初始化AFHTTPSessionManager相关属性
/**
 *  所有的HTTP请求共享一个AFHTTPSessionManager,原理参考地址:http://www.jianshu.com/p/5969bbb4af9f
 *  + (void)initialize该初始化方法在当用到此类时候只调用一次
 */
+ (void)initialize
{
    _manager = [AFHTTPSessionManager manager];
    //设置请求参数的类型:JSON (AFJSONRequestSerializer,AFHTTPRequestSerializer)
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //设置请求的超时时间
    _manager.requestSerializer.timeoutInterval = 60.f;
    //设置服务器返回结果的类型:JSON (AFJSONResponseSerializer,AFHTTPResponseSerializer)
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript", @"text/html",@"text/css",@"multipart/form-data",@"application/octet-stream",@"audio/x-wav",@"text/plain",@"text/xml", nil];
    //打开状态栏的等待菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [ICNetworkHelper fileManagerSet];
}

+ (void)fileManagerSet
{
    _fileManager = [AFHTTPSessionManager manager];
    _fileManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _fileManager.requestSerializer = [AFJSONRequestSerializer serializer];
    [_fileManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript", @"text/html",@"text/css",@"multipart/form-data",@"application/octet-stream",@"audio/x-wav", nil]];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}




#pragma mark - 重置AFHTTPSessionManager相关属性
+ (void)setRequestSerializer:(ICRequestSerializer)requestSerializer
{
    _manager.requestSerializer = requestSerializer==ICRequestSerializerHTTP ? [AFHTTPRequestSerializer serializer] : nil;
}

+ (void)setResponseSerializer:(ICResponseSerializer)responseSerializer
{
    _manager.responseSerializer = responseSerializer==ICResponseSerializerHTTP ? [AFHTTPResponseSerializer serializer] : nil;
}

+ (void)setRequestTimeoutInterval:(NSTimeInterval)time
{
    _manager.requestSerializer.timeoutInterval = time;
    _fileManager.requestSerializer.timeoutInterval = time;
}

+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field
{
    [_manager.requestSerializer setValue:value forHTTPHeaderField:field];
    [_fileManager.requestSerializer setValue:value forHTTPHeaderField:field];
}

+ (void)openNetworkActivityIndicator:(BOOL)open
{
    !open ? [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:NO] : nil ;
}

+ (void)setSecurityPolicy:(AFSecurityPolicy *)securityPolicy {
    [_manager setSecurityPolicy:securityPolicy];
    [_fileManager setSecurityPolicy:securityPolicy];
}

@end
