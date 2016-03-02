//
//  MBProgressHUD+AL.h
//  BusinessScale
//
//  Created by Alvin on 15/12/22.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (AL)


+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

+ (void)showMessage:(NSString *)message;

+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;


+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

// Alvin add
+ (void)showSuccess:(NSString *)success compleBlock:(MBProgressHUDCompletionBlock)back;
+ (void)showError:(NSString *)error compleBlock:(MBProgressHUDCompletionBlock)back;


+ (void)showSuccess:(NSString *)success toView:(UIView *)view compleBlock:(MBProgressHUDCompletionBlock)block;

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view compleBlock:(MBProgressHUDCompletionBlock)block;

@end
