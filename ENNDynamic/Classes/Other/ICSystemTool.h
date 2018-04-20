//
//  ICSystemTool.h
//  ICome
//
//  Created by chenqs on 2017/5/9.
//  Copyright © 2017年 iCom. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Block_Callback)();

@interface ICSystemTool : NSObject

+ (void)checkPhotoAuthorizationStatus:(Block_Callback)callback;
+ (void)checkCameraAuthorizationStatus:(Block_Callback)callback;
+ (void)checkAudioAuthorizationStatus:(Block_Callback)callback;

@end
