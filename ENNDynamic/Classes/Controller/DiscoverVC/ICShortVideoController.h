//
//  ICShortVideoController.h
//  ICome
//
//  Created by zhangrongwu on 16/5/4.
//  Copyright © 2016年 iCom. All rights reserved.
//  录制段视频控制器

#import "ICDynamicBaseViewController.h"

@interface ICShortVideoController : ICDynamicBaseViewController

- (void)show;

@property (nonatomic, copy) void (^finishOperratonBlock)(NSString *path);

@property (nonatomic, assign, readonly) BOOL isRecordingVideo;

@end
