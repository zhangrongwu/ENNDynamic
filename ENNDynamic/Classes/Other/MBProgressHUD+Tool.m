//
//  MBProgressHUD+Tool.m
//  ICome
//
//  Created by ENN on 16/2/19.
//  Copyright © 2016年 XianZhuangGuo. All rights reserved.
//

#import "MBProgressHUD+Tool.h"

@implementation MBProgressHUD (Tool)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [ICTools lastWindow];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    //[hud hide:YES afterDelay:1.0];
    [hud hideAnimated:YES afterDelay:1.0];
}



#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    //hud.dimBackground = NO;
    hud.backgroundView.color = [UIColor clearColor];
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

+ (void)showLoadingActivityView:(UIView *)view {
    [self showMessage:@"加载中..." toView:view];
}

+ (void)showProcessingActivityView:(UIView *)view {
    [self showMessage:@"处理中..." toView:view];
}

+ (void)showLoadingMessage:(NSString *)message toView:(UIView *)view
{
    [self showMessage:message toView:view];
}

+ (void)hideLoadingActivityView:(UIView *)view {
    [self hideHUDForView:view animated:YES];
}

+ (MBProgressHUD *)showHorizontalLoadingBarInView:(UIView *)view message:(NSString *)message {
    // 快速显示一个提示信息
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.userInteractionEnabled = YES;
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = message;
    [hud showAnimated:YES];
    return hud;
}



@end




