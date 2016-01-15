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
}

- (void)tap
{
    [self.view endEditing:YES];
}

- (IBAction)getVeryCode:(id)sender {
    [self.progressHud show:YES];
    LoginHttpTool *req = [[LoginHttpTool alloc]initWithParam:[LoginHttpTool getVeryCodeWithParams:@{@"uid":_kUIAccount.text,@"flag":@"1"}]];
    [req setReturnBlock:^(NSURLSessionTask *task,NSURLResponse *response, id responseObject) {
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                [MBProgressHUD showMessage:@"验证码已成功发送到您手机"];
            }
        }];
    }];
}

/// 提交点击事件
#pragma mark 提交点事件
-(IBAction)confirmClick:(id)sender {
    [self.progressHud show:YES];
    LoginHttpTool *req = [[LoginHttpTool alloc]initWithParam:[LoginHttpTool forgetPasswordWithParams:@{@"uid":_kUIAccount.text,@"password":_kUIPassword.text,@"vericode":_kUIVCode.text}]];
    [req setReturnBlock:^(NSURLSessionTask *task,NSURLResponse *response, id responseObject) {
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                [MBProgressHUD showSuccess:@"重置密码成功" compleBlock:^{
//                    LoginController *login = [[LoginController alloc]init];
//                    [login loginWithParams:@{@"uid":_kUIAccount.text,@"password":_kUIPassword.text}];
                    ALNavigationController *nav = (ALNavigationController *)self.navigationController;
                    if (nav.callBack) {
                        nav.callBack();
                        return;
                    }
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }];
            }
        }];
    }];
}

@end
