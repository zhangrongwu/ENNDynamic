//
//  MBProgressHUD+Tool.h
//  ICome
//
//  Created by ENN on 16/2/19.
//  Copyright © 2016年 XianZhuangGuo. All rights reserved.
//  MBProgressHUD工具类

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Tool)

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

+ (void)showLoadingActivityView:(UIView *)view;
+ (void)showProcessingActivityView:(UIView *)view;
+ (void)hideLoadingActivityView:(UIView *)view;

+ (void)showLoadingMessage:(NSString *)message toView:(UIView *)view;

+ (MBProgressHUD *)showHorizontalLoadingBarInView:(UIView *)view message:(NSString *)message;
@end
