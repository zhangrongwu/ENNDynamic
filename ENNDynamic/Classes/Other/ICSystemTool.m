//
//  ICSystemTool.m
//  ICome
//
//  Created by chenqs on 2017/5/9.
//  Copyright © 2017年 iCom. All rights reserved.
//

#import "ICSystemTool.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "ICTools.h"

@implementation ICSystemTool

+ (void)checkPhotoAuthorizationStatus:(Block_Callback)callback
{
    if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined)
    {
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            
            if (*stop) {
                if(callback)
                {
                    callback();
                }
            }
            *stop = TRUE;
            
        } failureBlock:^(NSError *error) {
            [self showAuthorizationStatusMessage:([NSString stringWithFormat:@"请在iPhone的“设置-隐私”选项中，允许iCome访问你的相册。"])];
        }];
    }
    else
    {
        
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied)
        {
            [self showAuthorizationStatusMessage:([NSString stringWithFormat:@"请在iPhone的“设置-隐私”选项中，允许iCome访问你的相册。"])];
        }
        else
        {
            if(callback)
            {
                callback();
            }
        }
    }
}

+ (void)checkCameraAuthorizationStatus:(Block_Callback)callback
{
    
//    if (![ICTools hasPermissionToGetCamera]) {
//
//        [self showAuthorizationStatusMessage:([NSString stringWithFormat:@"请在iPhone的“设置-隐私”选项中，允许iCome访问你的相机。"])];
//    } else {
//        if(callback)
//        {
//            callback();
//        }
//    }
    
}


+ (void)checkAudioAuthorizationStatus:(Block_Callback)callback
{
//    if (![[ICVideoManager shareManager] canRecordViedo]) {
//
//        [self showAuthorizationStatusMessage:([NSString stringWithFormat:@"请在iPhone的“设置-隐私”选项中，允许iCome访问你的摄像头和麦克风。"])];
//    } else {
//
//        if(callback)
//        {
//            callback();
//        }
//    }
}


+ (void)showAuthorizationStatusMessage:(NSString *)message
{

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:message message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alert show];
    
}


@end
