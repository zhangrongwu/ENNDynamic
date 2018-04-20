//
//  ICTools.h
//  ICome
//
//  Created by zhang_rongwu on 16/3/2.
//  Copyright © 2016年 XianZhuangGuo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICTools : NSObject
/** app版本:1.0*/
+(NSString *)getAppVersion;
/** buildVersion:201603021440*/
+(NSString *)getAppBuildVersion;
/** appName: iCome*/
+(NSString *)getAppDisplayName;
/** appId : cn.icom.dev.app*/
+(NSString *)getAppIdentifier;
/** 系统版本*/
+(NSString *)getSystemVersion;
/** 字符串判空*/
+(BOOL)stringEmpty:(NSString *)string;
/** 判空处理*/
+(BOOL)isObjEmpty:(id)obj;
/** 获取图片缓存*/
+(NSString *)getImageCacheSize;
/** 清理图片缓存*/
+(void)clearDisk;
/** 清理具体某个路径图片缓存*/
+(void)clearSDImageFromDiskWithCacheURL:(NSString *)URL;
/** 清理系统缓存*/
+(void)removeAllCachedResponses;
/** 是否允许定位*/
+(BOOL)hasPermissionToLocate;
/** 是否允许获取相机*/
+(BOOL)hasPermissionToGetCamera;
/** 麦克风权限*/
+(BOOL)hasPermissionToGetVoice;
/** 通讯录权限*/
+(BOOL)hasPermissionToAddressBook;
/** 是否有推送权限*/
+(BOOL)isAllowedNotification;
/** 拨打电话*/
+(void)tel:(NSString *)phone;
/** 电话号码正则表达式*/
+(BOOL)regularExpressionWithPhoneNumer:(NSString *)phoneNumber;
/** url*/
+(BOOL)regularExpressionWithURLString:(NSString *)string;
/** 设备唯一标识 uuid*/
+(NSString*)getDeviceId;
/** 获取设备类型 iPhone  iPod  iPad */
+(NSString*)getDeviceTypeInfo;
/** 最上层window */
+(UIWindow *)lastWindow;
/** 播放系统提示音 */
+(void)playMsgSoundWithStatus:(NSInteger)status;
/** 获取网络类型*/
+(NSString *)getNetWorkType;
/** 清除消息缓存 */
+ (void)clearMessageCaches;
/** 退出登录*/
+(void)outLogIn;
/** 退出登录逻辑 重复账号不清理数据、新账号清理用户数据 */
+(void)clearAllLocateInfo;
/** 初始化 app*/
+(void)initICom;

/**检证邮箱*/
+(BOOL) validateEmail:(NSString *)emailName;

//// 重新登录不同账号需要清除的
//+ (void)clearMessageForLogin;

// 计算字符串的字节数（1汉字按2字节）
+ (int)charNumber:(NSString*)strtemp;
// pdf、doc、doct等文件
+ (BOOL)isFile:(NSString *)type;
// mp3、amr、aac等文件
+ (BOOL)isVoiceFrequency:(NSString *)type;
// png、jpeg、gif等文件
+ (BOOL)isImage:(NSString *)type;

+ (BOOL)isIPhoneX;

// 加线
+ (UIView*)drawLineWithSuperView:(UIView*)superView Color:(UIColor*)color Frame:(CGRect)frame;

+ (void)setDownLoadImageToken:(NSString *)token;
// 获取机型 iphone 7  8p
+ (NSString*)getIphoneType;
// 获取ip地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4;
@end
