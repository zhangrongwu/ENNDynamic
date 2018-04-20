//
//  ICNetworkHelper.h
//  ICome
//
//  Created by zhangrongwu on 16/9/14.
//  Copyright © 2016年 iCom. All rights reserved.
//  http请求中间层封装

#import <Foundation/Foundation.h>
#import "EnnDynamicHeader.h"
typedef NS_ENUM(NSUInteger, ICRequestSerializer) {
    /** 设置请求数据为JSON格式*/
    ICRequestSerializerJSON,
    /** 设置请求数据为二进制格式*/
    ICRequestSerializerHTTP,
};

typedef NS_ENUM(NSUInteger, ICResponseSerializer) {
    /** 设置响应数据为JSON格式*/
    ICResponseSerializerJSON,
    /** 设置响应数据为二进制格式*/
    ICResponseSerializerHTTP,
};

/** 请求成功回调*/
typedef void (^HttpRequestSuccess)(id responseObject);
/** 请求失败回调*/
typedef void (^HttpRequestFailed)(NSError *error);
/** 缓存回调*/
typedef void (^HttpRequestCache)(id responseCache);
/** 上传或者下载的进度*/
typedef void (^HttpProgress)(NSProgress *progress);

@interface ICNetworkHelper : NSObject
/**
 *  GET请求,无缓存
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 *
 *  @return 请求返回的对象
 */
+(__kindof NSURLSessionTask *)GET:(NSString *)URL
                       parameters:(NSDictionary *)parameters
                          success:(HttpRequestSuccess)success
                          failure:(HttpRequestFailed)failure;
/**
 *  GET请求,自动缓存
 *
 *  @param URL           请求地址
 *  @param parameters    请求参数
 *  @param responseCache 缓存数据的回调
 *  @param success       请求成功的回调
 *  @param failure       请求失败的回调
 *
 *  @return 返回的对象
 */
+ (__kindof NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(NSDictionary *)parameters
                     responseCache:(HttpRequestCache)responseCache
                           success:(HttpRequestSuccess)success
                           failure:(HttpRequestFailed)failure;

/**
 *  POST请求,无缓存
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 *
 *  @return 请求返回的对象
 */
+(__kindof NSURLSessionTask *)POST:(NSString *)URL
                        parameters:(NSDictionary *)parameters
                           success:(HttpRequestSuccess)success
                           failure:(HttpRequestFailed)failure;

/**
 *  POST请求,自动缓存
 *
 *  @param URL           请求地址
 *  @param parameters    请求参数
 *  @param responseCache 缓存数据的回调
 *  @param success       请求成功的回调
 *  @param failure       请求失败的回调
 *
 *  @return 返回的对象
 */
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                      responseCache:(HttpRequestCache)responseCache
                            success:(HttpRequestSuccess)success
                            failure:(HttpRequestFailed)failure;

/**
 *  上传图片文件
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param data       文件二进制
 *  @param name       文件对应服务器上的字段(file image等)
 *  @param fileName   文件名 （20160724....）
 *  @param mimeType   图片文件的类型,例:image/png  image/jpeg  audio/mpeg 等....
 *  @param progress   上传进度信息
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象
 */
+ (__kindof NSURLSessionTask *)uploadWithURL:(NSString *)URL
                                  parameters:(NSDictionary *)parameters
                                      data:(NSData *)data
                                        name:(NSString *)name
                                    fileName:(NSString *)fileName
                                    mimeType:(NSString *)mimeType
                                    progress:(HttpProgress)progress
                                     success:(HttpRequestSuccess)success
                                     failure:(HttpRequestFailed)failure;

/**
 *  下载文件
 *
 *  @param URL      请求地址
 *  @param fileDir  文件存储目录(默认存储目录为Download)
 *  @param progress 文件下载的进度信息
 *  @param success  下载成功的回调(回调参数filePath:文件的路径)
 *  @param failure  下载失败的回调
 *
 *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，开始下载调用resume方法
 */
+ (__kindof NSURLSessionTask *)downloadWithURL:(NSString *)URL
                                       fileDir:(NSString *)fileDir
                                      fileName:(NSString *)fileName
                                      progress:(HttpProgress)progress
                                       success:(void(^)(NSString *filePath))success
                                       failure:(HttpRequestFailed)failure;
/**
 *  业务需求 特殊下载文件
 *
 *  @param URL           请求地址
 *  @param parameters    下载文件参数
 *  @param success       下载成功回调
 *  @param failure       下载失败回调
 *
 *  @return 返回的对象
 */
+ (__kindof NSURLSessionTask *)GETFile:(NSString *)URL
                            parameters:(NSDictionary *)parameters
                              progress:(void(^)(NSProgress *pro))progress
                               success:(HttpRequestSuccess)success
                               failure:(HttpRequestFailed)failure;



#pragma mark - 重置AFHTTPSessionManager 自定义相关属性
/**
 *  设置网络请求参数的格式:默认为JSON格式
 *
 *  @param requestSerializer PPRequestSerializerJSON(JSON格式),PPRequestSerializerHTTP(二进制格式),
 */
+ (void)setRequestSerializer:(ICRequestSerializer)requestSerializer;

/**
 *  设置服务器响应数据格式:默认为JSON格式
 *
 *  @param responseSerializer PPResponseSerializerJSON(JSON格式),PPResponseSerializerHTTP(二进制格式)
 */
+ (void)setResponseSerializer:(ICResponseSerializer)responseSerializer;

/**
 *  设置请求超时时间:默认为30S
 *
 *  @param time 时长
 */
+ (void)setRequestTimeoutInterval:(NSTimeInterval)time;

/**
 *  设置请求头
 */
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

/**
 *  是否打开网络状态转圈菊花:默认打开
 *
 *  @param open YES(打开), NO(关闭)
 */
+ (void)openNetworkActivityIndicator:(BOOL)open;
/**
 *  设置https相关内容
 *
 *  @param securityPolicy Certificates等
 */
+ (void)setSecurityPolicy:(AFSecurityPolicy *)securityPolicy;

@end
