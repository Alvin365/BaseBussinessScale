//
//  ResetPwdController.m
//  btWeigh
//
//  Created by mac on 15/6/2.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "ResetPwdController.h"
#import "LoginHttpTool.h"
#import "LoginController.h"
#import "ALNavigationController.h"
@interface ResetPwdController ()
{
     NSTimer *_timer;
}
@end

@implementation ResetPwdController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeLineOfNavigationBar];
    [self initAll];
}

#pragma mark - custom function
/// 初始化
#pragma mark 初始化
-(void)initAll {
    // 国际化
    self.title =  @"密码重置";
    _kUIAccount.placeholder =  @"手机号";
    _kUIPassword.placeholder = @"新密码";
    _kUIConfirmPwd.placeholder = @"确认新密码";
    _kUIVCode.placeholder =  @"验证码";
    [_kUIGetVCode setTitle: @"获取验证码" forState:UIControlStateNormal];
    _kUIGetVCode.layer.cornerRadius = 5;
    _kUIGetVCode.layer.masksToBounds = YES;
    _kUIGetVCode.backgroundColor = [UIColor whiteColor];
    [_kUIConfirm setTitle: @"提交" forState:UIControlStateNormal];
    // 色差
    [_kUIConfirm setTitleColor:ALNavBarColor forState:UIControlStateNormal];
    [_kUIGetVCode setTitleColor:ALNavBarColor forState:UIControlStateNormal];
    _kUIAccount.tintColor = Color(255, 255, 255, 1);
    _kUIPassword.tintColor = Color(255, 255, 255, 1);
    _kUIVCode.tintColor = Color(255, 255, 255, 1);
    _kUIConfirmPwd.tintColor = Color(255, 255, 255, 1);
    self.view.backgroundColor = ALNavBarColor;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)]];
    
    if (self.tele) {
        self.kUIAccount.text = self.tele;
    }
    
    [self addTimer];
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)tap
{
    [self.view endEditing:YES];
}

- (void)addTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(freshTimer) userInfo:nil repeats:YES];
}

- (void)freshTimer
{
    _kUIGetVCode.tag -= 1;
    [_kUIGetVCode setTitle:[NSString stringWithFormat:@"%lds后重发",(long)_kUIGetVCode.tag] forState:UIControlStateNormal];
    [_kUIGetVCode setTitle:[NSString stringWithFormat:@"%lds后重发",(long)_kUIGetVCode.tag] forState:UIControlStateHighlighted];
    _kUIGetVCode.titleLabel.text = [NSString stringWithFormat:@"%lds后重发",(long)_kUIGetVCode.tag];
    if (_kUIGetVCode.tag == 0) {
        _kUIGetVCode.tag = 1;
        [_timer pauseTimer];
        [_kUIGetVCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        _kUIGetVCode.titleLabel.text = @"获取验证码";
    }
}

- (IBAction)getVeryCode:(id)sender {
    if ([sender tag]>1) {
        [MBProgressHUD showMessage:@"验证码已经发送，请稍后"];
        return;
    }
    
    if (![ALCommonTool verifyMobilePhone:self.kUIAccount.text]) {
        [MBProgressHUD showMessage:@"手机号码不正确"];
        return;
    }
    
    [self.progressHud show:YES];
    LoginHttpTool *req = [[LoginHttpTool alloc]initWithParam:[LoginHttpTool getVeryCodeWithParams:@{@"uid":_kUIAccount.text,@"flag":@"1"}]];
    [req setReturnBlock:^(NSURLSessionTask *task,NSURLResponse *response, id responseObject) {
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                _kUIGetVCode.tag = 120;
                [_timer setFireDate:[NSDate date]];
                [MBProgressHUD showMessage:@"验证码已成功发送到您手机"];
            }
        }];
    }];
}

/// 提交点击事件
#pragma mark 提交点事件
-(IBAction)confirmClick:(id)sender {
    if (![ALCommonTool verifyMobilePhone:self.kUIAccount.text]) {
        [MBProgressHUD showMessage:@"手机号码不正确"];
        return;
    }
    if (!self.kUIPassword.text.length) {
        [MBProgressHUD showMessage:@"请输入新密码"];
        return;
    }
    if (![self.kUIConfirmPwd.text isEqualToString:self.kUIPassword.text]) {
        [MBProgressHUD showMessage:@"确认密码与新密码不匹配，请重新输入"];
        self.kUIConfirmPwd.text = nil;
        return;
    }
    if (!self.kUIVCode.text.length) {
        [MBProgressHUD showMessage:@"请输入验证码"];
        return;
    }
    [self.progressHud show:YES];
    LoginHttpTool *req = [[LoginHttpTool alloc]initWithParam:[LoginHttpTool forgetPasswordWithParams:@{@"uid":_kUIAccount.text,@"password":_kUIPassword.text,@"vericode":_kUIVCode.text}]];
    [req setReturnBlock:^(NSURLSessionTask *task,NSURLResponse *response, id responseObject) {
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                [MBProgressHUD showSuccess:@"重置密码成功" compleBlock:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            }
        }];
    }];
}

@end
