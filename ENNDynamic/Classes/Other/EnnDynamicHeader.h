//
//  EnnDynamicHeader.h
//  ENNDynamic
//
//  Created by zhangrongwu on 2018/4/20.
//

#ifndef EnnDynamicHeader_h
#define EnnDynamicHeader_h
#import <YYKit/YYKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "AFNetworking.h"
#import "MLLinkLabel.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "ICTools.h"
#import "ICUser.h"
#import "ICNetworkManager.h"
#import "ICSystemTool.h"

#import "NSString+Extension.h"
//#import "UIView+Extension.h"
#import "NSDate+Extension.h"
#import "UIBarButtonItem+Item.h"
#import "MBProgressHUD+Tool.h"
#import "NSDictionary+JSONExtemsion.h"
#import "UIView+Extension.h"


#define TOKEN @""
#define JSTICKET @""



// 应用程序的屏幕高度
#define APP_Frame_Height   [[UIScreen mainScreen] bounds].size.height
// 应用程序的屏幕宽度
#define App_Frame_Width    [[UIScreen mainScreen] bounds].size.width

#define App_RootCtr  [UIApplication sharedApplication].keyWindow.rootViewController

#define WEAKSELF __weak typeof(self) weakSelf = self;

#define FILEMAXIMAGE(ID) @"ID"
#define FILEOGLIMAGE(ID) @"ID"
#define MAXIMAGEURL(MAX_ID) @"id"
#define MINIMAGEURL(ID) @"id"
#define BASEURL @""

#define IColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define BACKGROUNDCOLOR   ICRGB(0xefefef) //ICRGB(0xf4f1f1)
#define ICFont(FONTSIZE)  [UIFont systemFontOfSize:(FONTSIZE)]
#define ICBOLDFont(FONTSIZE)  [UIFont boldSystemFontOfSize:(FONTSIZE)]

#define NotificationUpdateDiscoverNews @"NotificationUpdateDiscoverNews"
#define NotificationUpdateDVideoView @"NotificationUpdateDVideoView"
#define NotificationChangeUIView @"NotificationChangeUIView"

#define ICRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]
#define MESSAGEURLDEFAULTCOLOR ICRGB(0x3498fe)

#define DiscContentWidth (App_Frame_Width - 75)
#define HEIGHT_STATUSBAR  CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) // 状态栏高度
#define ContactHeadImageHeight (48.0f )   // 详细页的 cell头像图

#define HEIGHT_NAVBAR    44 // nav高度
#define HEIGHT_NAVBAR_X (HEIGHT_STATUSBAR + HEIGHT_NAVBAR)

#define HEIGHT_TABBAR   49  // tabbar 高度
#define HEIGHT_HOMEBAR  (iPhoneX ? 34 : 0) // X homebar 高度
#define HEIGHT_TABBAR_X (HEIGHT_TABBAR + HEIGHT_HOMEBAR)
#define kChildPath @"Chat/File"   // 暂时为这个存储文件


#define kVideoType @".mp4"        // video类型
#define kRecoderType @".wav"


//#define kChatRecoderPath @"Chat/Recoder"
#define kRecodAmrType @".amr"

#define kDiscvoerVideoPath @"Download/Video"  // video子路径
#define isDisdetailVC [[NSUserDefaults standardUserDefaults] boolForKey:@"isDisdetailVC"]



#define TypeDyPicURL @"TypeDyPicURL"
#define TypeDyVideo @"TypeDyVideo"
#define TypeDyMPic @"TypeDyMPic"
#define TypeDyPic @"TypeDyPic"
#define TypeDyText @"TypeDyText"




#endif /* EnnDynamicHeader_h */


