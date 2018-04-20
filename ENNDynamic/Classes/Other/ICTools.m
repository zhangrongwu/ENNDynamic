//
//  ICTools.m
//  ICome
//
//  Created by zhang_rongwu on 16/3/2.
//  Copyright © 2016年 XianZhuangGuo. All rights reserved.
//

#import "ICTools.h"
#import "ICFileTool.h"
#import <AddressBook/AddressBook.h>


#import <sys/utsname.h>

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
#import "EnnDynamicHeader.h"
@implementation ICTools

+(NSString *)getAppVersion {
    //    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    return appVersion;
}


+(NSString *)getAppBuildVersion {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appBuildVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    return appBuildVersion;
}

+(NSString *)getAppDisplayName {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *displayName = [infoDic objectForKey:@"CFBundleDisplayName"];
    
    return displayName;
}

+(NSString *)getAppIdentifier {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appIdentifier = [infoDic objectForKey:@"CFBundleIdentifier"];
    return appIdentifier;
}

+(NSString *)getSystemVersion {
    NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
    return iOSVersion;
}

+(BOOL)stringEmpty:(NSString *)string {
    if (nil == string || [@"" isEqualToString:string] || string == NULL || [string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}
+(BOOL)isObjEmpty:(id)obj {
    if ([obj isKindOfClass:[NSNull class]] || [obj isEqual:@"null"] || obj == nil || obj == [NSNull null] || [obj isEqual:[NSNull null]] || ![obj isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    return NO;
}

+(NSString *)getImageCacheSize {
    //    NSLog(@" ++++++ %ld", (long)[[YYImageCache sharedCache].diskCache totalCost]);
    //    NSLog(@"%f,%f",[[YYImageCache sharedCache].diskCache totalCost],[[SDImageCache sharedImageCache] getSize]);
    NSInteger  sizelong =([[YYImageCache sharedCache].diskCache totalCost] + [[SDImageCache sharedImageCache] getSize]);
    CGFloat size = (long)sizelong / (1024.0 * 1024.0);
    size = size + 0.000001;
    return  [NSString stringWithFormat:@"%.2fM", size];
}

+(void)clearDisk {
    //SD image Cache
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
    //YY image Cache
    [[YYImageCache sharedCache].memoryCache removeAllObjects];
    [[YYImageCache sharedCache].diskCache removeAllObjects];
    // 清除缓存后需要重新设置token
    [ICTools setDownLoadImageToken:TOKEN];
}

+(void)clearSDImageFromDiskWithCacheURL:(NSString *)URL {
    
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] removeImageForKey:URL];
}

+(void)removeAllCachedResponses {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        NSSet *websiteDataTypes = [NSSet setWithArray:@[
                                                        WKWebsiteDataTypeDiskCache,
                                                        //WKWebsiteDataTypeOfflineWebApplicationCache,
                                                        WKWebsiteDataTypeMemoryCache,
                                                        //WKWebsiteDataTypeLocalStorage,
                                                        //WKWebsiteDataTypeCookies,
                                                        //WKWebsiteDataTypeSessionStorage,
                                                        //WKWebsiteDataTypeIndexedDBDatabases,
                                                        //WKWebsiteDataTypeWebSQLDatabases
                                                        ]];
        //// All kinds of data
        //NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        //// Date from
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        //// Execute
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            // Done
        }];
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}

#pragma 权限
+(BOOL)hasPermissionToLocate
{
    BOOL hasPermission = YES;
    if (![CLLocationManager locationServicesEnabled]) {
        hasPermission = NO;
    }
    return hasPermission;
}

+(BOOL)hasPermissionToGetCamera
{
    // 判断是否在访问限制（家长控制）下关闭了相机 或 设备没有摄像头
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        return NO;
    }
    // 判断是否在隐私中关闭了相机
    BOOL hasPermission = YES;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        hasPermission = NO;
    }
    return hasPermission;
}
+(BOOL)hasPermissionToGetVoice { // 语音与相机相同方法
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        return NO;
    }
    BOOL hasPermission = YES;
    AVAuthorizationStatus voiceAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (voiceAuthStatus == AVAuthorizationStatusRestricted || voiceAuthStatus == AVAuthorizationStatusDenied) {// 未授权
        hasPermission = NO;
    }
    return hasPermission;
}

+(BOOL)hasPermissionToAddressBook { // 未实现
    BOOL hasPermission = YES;
    return hasPermission;
}

+(BOOL)isAllowedNotification {
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (UIUserNotificationTypeNone != setting.types) {
        return YES;
    }
    return NO;
}

+(void)tel:(NSString *)phone {
    if (![self stringEmpty:phone] && [self regularExpressionWithPhoneNumer:phone]) {
        UIWebView * callWebview =[[UIWebView alloc] init];
        NSURL *telURL =[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phone]];
        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
        [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
    }
}

/** 电话号码正则表达式*/
+(BOOL)regularExpressionWithPhoneNumer:(NSString *)phoneNumber {
    NSString *pattern = @"((\\d{11})|^((\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})|(\\d{4}|\\d{3})-(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1})|(\\d{7,8})-(\\d{4}|\\d{3}|\\d{2}|\\d{1}))$)";
    //    NSString *pattern = @"^1[34578]\\d{9}$";
    //    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSPredicate *regexmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [regexmobile evaluateWithObject:phoneNumber];
}

+(BOOL)regularExpressionWithURLString:(NSString *)string {
    //    NSString *pattern = @"[a-zA-z]+://[^\\s]*";
    NSString *pattern = @"((ftp|https?)://[-\\w]+(\\.\\w[-\\w]*)+|(?i:[a-z0-9](?:[-a-z0-9]*[a-z0-9])?\\.)+(?-i:com\\b|edu\\b|biz\\b|gov\\b|in(?:t|fo)\\b|mil\\b|net\\b|org\\b|[a-z][a-z]\\b))(:\\d+)?(/[^.!,?;\"\'<>()\\[\\]{}\\s\\x7F-\\xFF]*(?:[.!,?]+[^.!,?;\"\'<>()\\[\\]{}\\s\\x7F-\\xFF]+)*)?";
    NSPredicate *regexmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [regexmobile evaluateWithObject:string];
}

+(NSString*)getDeviceId {
    NSDictionary *dic =[[NSBundle mainBundle] infoDictionary];//获取info－plist
    NSString *appIdentifier  = [dic objectForKey:@"CFBundleIdentifier"];
    NSString *currentDeviceUUIDStr = [SSKeychain passwordForService:appIdentifier account:@"uuid"];
    if ([ICTools stringEmpty:currentDeviceUUIDStr]) {
        NSUUID *currentDeviceUUID = [UIDevice currentDevice].identifierForVendor;
        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
        
        [SSKeychain setPassword: currentDeviceUUIDStr forService:appIdentifier account:@"uuid"];
    }
    NSString *mId = [ICMD5 md5:currentDeviceUUIDStr];
    NSLog(@"设备唯一标识 ： %@", mId);
    // 加一下密
    return mId;
}

+(NSString*)getDeviceTypeInfo {
    NSString *deviceType = [[UIDevice currentDevice] model];
    if ([deviceType isEqualToString:@"iPad"]) {
        return @"2";
    } else {
        return @"1";
    }
    return deviceType;
}
//ios获取最上层window的正确方法
+(UIWindow *)lastWindow
{
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in [windows reverseObjectEnumerator]) {
        NSLog(@"window = %@",window);
        if ([window isKindOfClass:[UIWindow class]]
            && window.windowLevel == UIWindowLevelNormal
            && CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds)) {
            return window;
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}

+(void)playMsgSoundWithStatus:(NSInteger)status {
    if (!status) {// 免打扰状态 (0:正常 1:是) 全局与某个组 后台做了处理
        AudioServicesPlaySystemSound(1007); // 1007为系统默认提示音
    } else {
        //        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate); // 只振动
    }
}

+(NSString *)getNetWorkType {
    YYReachability *reachability  = [[YYReachability alloc] init];
    NSLog(@"%lu",     (unsigned long)reachability.status);
    if (reachability.status == 0) {
        return @"none";
    }
    if (reachability.status == 2) {
        return @"wifi";
    }
    if (reachability.status == 1) {
        switch (reachability.wwanStatus) {
            case YYReachabilityWWANStatusNone:{
                return @"none";
            }
                break;
            case YYReachabilityWWANStatus2G:{
                return @"2G";
            }
                break;
            case YYReachabilityWWANStatus3G: {
                return @"3G";
            }
                break;
            case YYReachabilityWWANStatus4G: {
                return @"4G";
            }
                break;
            default:
                break;
        }
    }
    return @"无网络";
}

+(void)outLogIn {
    //    /**
    //     *
    //     *  处理再次登录逻辑
    //     *  再次登录: id为旧id时不清除数据
    //     *  为新id时清除本地数据 <逻辑问题，暂未处理>
    //     */
    [[ICAsyncSocketManager sharedInstance] disconnectSocket]; // 断开长连接
    [[ICLoginNetworkManager sharedInstance] logout]; // 向服务器请求推出登录操作
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Token"]; // 清除token
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    ICLoginViewController *loginVC = [[ICLoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    App_RootCtr = nav;
}

+(void)clearAllLocateInfo {
    [ICMessageHelper setLastUpdate:@0]; // lastUpdate 置为0
    [ICMessageHelper setDirectLastUpdate:@0];
    [ICFileTool clearUserDefaults];
    //    [[ICDatabaseManager shareManager] cleanDB];// delete 数据库表文件
    [[ICDatabaseManager shareManager] dropAllTable];
    [[ICLKBaseManager getUsingLKDBHelper] dropAllTable]; //邮箱对应的数据库表
    //    [[ICLCBFMDBManager shareManager] dropDB];
    [ICTools clearDisk]; // 清除图片等 缓存
    [ICCacheFileManager clearFile]; // 清理本地文件
    
    
    [ICNewsDatabase deleteAllNewsTitle];//清除新闻数据
    [ICScheduleDatabase deleteAllSchedule];//清除日程数据
    //NSString *keyStr = [NSString stringWithFormat:@"%@_%@",News_reload,[ICUser currentUser].eId];
    //[ICCacheTool saveCache:keyStr reload:NO];
    
    NSUserDefaults * jobDefaults = [NSUserDefaults standardUserDefaults];
    [jobDefaults setObject:nil forKey:@"jobAppClassList"];
    [jobDefaults setObject:nil forKey:@"CreateAppClassList"];
    [jobDefaults synchronize];
    
    
    sleep(2);
}

+(void)initICom {
    if (![ICTools stringEmpty:TOKEN]) {
        [[ICAsyncSocketManager sharedInstance] disconnectSocket]; // 断开长连接
        [[ICLoginNetworkManager sharedInstance] logout]; // 向服务器请求推出登录操作
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Token"]; // 清除token
        [[NSUserDefaults standardUserDefaults] synchronize];
        [ICUser releaseUser];
        [ICTools clearAllLocateInfo];
        ICLoginViewController *loginVC = [[ICLoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        App_RootCtr = nav;
    }
}

+ (void)clearMessageCaches
{
    [ICMessageHelper setLastUpdate:@0]; // lastUpdate 置为0
    [ICMessageHelper setDirectLastUpdate:@0];
    [ICFileTool clearUserDefaults];
    [ICCacheFileManager clearFile]; // 清理本地文件
    [ICMessageDatabase deleteAllMessages];
}

// 计算字符串的字节数（1汉字按2字节）
+ (int)charNumber:(NSString*)strtemp {
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}


// pdf、doc、doct等文件
+ (BOOL)isFile:(NSString *)type {
    if ([type isEqualToString:@"pdf"]||
        [type isEqualToString:@"doc"]||
        [type isEqualToString:@"docx"]||
        [type isEqualToString:@"xls"]||
        [type isEqualToString:@"xlsx"]||
        [type isEqualToString:@"ppt"]||
        [type isEqualToString:@"pptx"]||
        [type isEqualToString:@"pps"]||
        [type isEqualToString:@"txt"]) {
        return YES;
    }
    return NO;
}
// mp3、amr、aac等文件
+ (BOOL)isVoiceFrequency:(NSString *)type {
    if ([type isEqualToString:@"mp3"]||
        [type isEqualToString:@"amr"]||
        [type isEqualToString:@"wav"]||
        [type isEqualToString:@"aac"]||
        [type isEqualToString:@"wma"]||
        [type isEqualToString:@"ogg"]||
        [type isEqualToString:@"ape"]) {
        return YES;
    }
    return NO;
}

// png、jpeg、gif等文件
+ (BOOL)isImage:(NSString *)type {
    if ([type isEqualToString:@"png"]||
        [type isEqualToString:@"jpg"]||
        [type isEqualToString:@"jpeg"]||
        [type isEqualToString:@"gif"]||
        [type isEqualToString:@"bmp"]||
        [type isEqualToString:@"tiff"]||
        [type isEqualToString:@"svg"]||
        [type isEqualToString:@"PNG"]) {
        return YES;
    }
    return NO;
}


+(BOOL) validateEmail:(NSString *)emailName
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailName];
}



//  自定义线条
+ (UIView*)drawLineWithSuperView:(UIView*)superView Color:(UIColor*)color Frame:(CGRect)frame{
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = color;
    [superView addSubview:line];
    return line;
}


+ (void)setDownLoadImageToken:(NSString *)token {
    [YYWebImageManager sharedManager].headers = @{@"Accept": @"image/*;q=0.8", @"token":token};
    [SDWebImageDownloader sharedDownloader].HTTPHeaders = [@{@"Accept": @"image/*;q=0.8", @"token":token} mutableCopy];
}

+ (BOOL)isIPhoneX {
    return ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO);
}
// 设备类型
+ (NSString*)getIphoneType {
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"])  return@"iPhone2G";
    
    if([platform isEqualToString:@"iPhone1,2"])  return@"iPhone3G";
    
    if([platform isEqualToString:@"iPhone2,1"])  return@"iPhone3GS";
    
    if([platform isEqualToString:@"iPhone3,1"])  return@"iPhone4";
    
    if([platform isEqualToString:@"iPhone3,2"])  return@"iPhone4";
    
    if([platform isEqualToString:@"iPhone3,3"])  return@"iPhone4";
    
    if([platform isEqualToString:@"iPhone4,1"])  return@"iPhone4S";
    
    if([platform isEqualToString:@"iPhone5,1"])  return@"iPhone5";
    
    if([platform isEqualToString:@"iPhone5,2"])  return@"iPhone5";
    
    if([platform isEqualToString:@"iPhone5,3"])  return@"iPhone5c";
    
    if([platform isEqualToString:@"iPhone5,4"])  return@"iPhone5c";
    
    if([platform isEqualToString:@"iPhone6,1"])  return@"iPhone5s";
    
    if([platform isEqualToString:@"iPhone6,2"])  return@"iPhone5s";
    
    if([platform isEqualToString:@"iPhone7,1"])  return@"iPhone6Plus";
    
    if([platform isEqualToString:@"iPhone7,2"])  return@"iPhone6";
    
    if([platform isEqualToString:@"iPhone8,1"])  return@"iPhone6s";
    
    if([platform isEqualToString:@"iPhone8,2"])  return@"iPhone6sPlus";
    
    if([platform isEqualToString:@"iPhone8,4"])  return@"iPhoneSE";
    
    if([platform isEqualToString:@"iPhone9,1"])  return@"iPhone7";
    
    if([platform isEqualToString:@"iPhone9,2"])  return@"iPhone7Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return@"iPhone8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return@"iPhone8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return@"iPhone8Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return@"iPhone8Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return@"iPhoneX";
    
    if([platform isEqualToString:@"iPhone10,6"]) return@"iPhoneX";
    
    if([platform isEqualToString:@"iPod1,1"])  return@"iPodTouch1G";
    
    if([platform isEqualToString:@"iPod2,1"])  return@"iPodTouch2G";
    
    if([platform isEqualToString:@"iPod3,1"])  return@"iPodTouch3G";
    
    if([platform isEqualToString:@"iPod4,1"])  return@"iPodTouch4G";
    
    if([platform isEqualToString:@"iPod5,1"])  return@"iPodTouch5G";
    
    if([platform isEqualToString:@"iPad1,1"])  return@"iPad1G";
    
    if([platform isEqualToString:@"iPad2,1"])  return@"iPad2";
    
    if([platform isEqualToString:@"iPad2,2"])  return@"iPad2";
    
    if([platform isEqualToString:@"iPad2,3"])  return@"iPad2";
    
    if([platform isEqualToString:@"iPad2,4"])  return@"iPad2";
    
    if([platform isEqualToString:@"iPad2,5"])  return@"iPadMini1G";
    
    if([platform isEqualToString:@"iPad2,6"])  return@"iPadMini1G";
    
    if([platform isEqualToString:@"iPad2,7"])  return@"iPadMini1G";
    
    if([platform isEqualToString:@"iPad3,1"])  return@"iPad3";
    
    if([platform isEqualToString:@"iPad3,2"])  return@"iPad3";
    
    if([platform isEqualToString:@"iPad3,3"])  return@"iPad3";
    
    if([platform isEqualToString:@"iPad3,4"])  return@"iPad4";
    
    if([platform isEqualToString:@"iPad3,5"])  return@"iPad4";
    
    if([platform isEqualToString:@"iPad3,6"])  return@"iPad4";
    
    if([platform isEqualToString:@"iPad4,1"])  return@"iPadAir";
    
    if([platform isEqualToString:@"iPad4,2"])  return@"iPadAir";
    
    if([platform isEqualToString:@"iPad4,3"])  return@"iPadAir";
    
    if([platform isEqualToString:@"iPad4,4"])  return@"iPadMini2G";
    
    if([platform isEqualToString:@"iPad4,5"])  return@"iPadMini2G";
    
    if([platform isEqualToString:@"iPad4,6"])  return@"iPadMini2G";
    
    if([platform isEqualToString:@"iPad4,7"])  return@"iPadMini3";
    
    if([platform isEqualToString:@"iPad4,8"])  return@"iPadMini3";
    
    if([platform isEqualToString:@"iPad4,9"])  return@"iPadMini3";
    
    if([platform isEqualToString:@"iPad5,1"])  return@"iPadMini4";
    
    if([platform isEqualToString:@"iPad5,2"])  return@"iPadMini4";
    
    if([platform isEqualToString:@"iPad5,3"])  return@"iPadAir2";
    
    if([platform isEqualToString:@"iPad5,4"])  return@"iPadAir2";
    
    if([platform isEqualToString:@"iPad6,3"])  return@"iPadPro9.7";
    
    if([platform isEqualToString:@"iPad6,4"])  return@"iPadPro9.7";
    
    if([platform isEqualToString:@"iPad6,7"])  return@"iPadPro12.9";
    
    if([platform isEqualToString:@"iPad6,8"])  return@"iPadPro12.9";
    
    if([platform isEqualToString:@"i386"])  return@"iPhoneSimulator";
    
    if([platform isEqualToString:@"x86_64"])  return@"iPhoneSimulator";

    return platform;
}

// 获取ip地址
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL * _Nonnull stop) {
        address = addresses[key];
        //筛选出IP地址格式
        if([self isValidatIP:address]) *stop = YES;
    }];

    return address ? address : @"0.0.0.0";
}

+ (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            NSLog(@"%@",result);
            return YES;
        }
    }
    return NO;
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}
@end




