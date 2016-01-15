//
//  MBProgressHUD+AL.m
//  BusinessScale
//
//  Created by Alvin on 15/12/22.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "MBProgressHUD+AL.h"

@implementation MBProgressHUD (AL)

#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.5];
}

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view compleBlock:(MBProgressHUDCompletionBlock)block
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //    hud.labelText = text;
    hud.detailsLabelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.completionBlock = block;
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.5f];
}
#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view compleBlock:(MBProgressHUDCompletionBlock)block{
    [self show:success icon:@"success.png" view:view compleBlock:block];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    //    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //    RootTabViewController *root = (RootTabViewController *)delegate.window.rootViewController;
    //    if (view == nil) view = root.view;
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showMessage:(NSString *)msg
{
    [self show:msg icon:nil view:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
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

+ (void)showSuccess:(NSString *)success compleBlock:(MBProgressHUDCompletionBlock)back
{
    [self showSuccess:success toView:nil compleBlock:back];
}


@end
