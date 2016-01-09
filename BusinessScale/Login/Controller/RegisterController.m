//
//  RegisterController.m
//  btWeigh
//
//  Created by mac on 15/6/2.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "RegisterController.h"
#import "LienceController.h"
#import "LogonController.h"
#import "LoginController.h"
#import "NSString+WPAttributedMarkup.h"
#import "WPAttributedStyleAction.h"
#import "WPHotspotLabel.h"
#import "LoginHttpTool.h"

@interface RegisterController ()

@end

@implementation RegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}


#pragma mark - custom functions
/// 初始化
#pragma mark 初始化
-(void)initAll {
    self.title = @"注册";
    [self removeLineOfNavigationBar];
    // 色差
    [_kUIRegister setTitleColor:ALNavBarColor forState:UIControlStateNormal];
    [_kUIGetVCode setTitleColor:ALNavBarColor forState:UIControlStateNormal];
    self.view.backgroundColor = ALNavBarColor;
    _kUIAccount.tintColor = Color(255, 255, 255, 1);
    _kUIPassword.tintColor = Color(255, 255, 255, 1);
    _kUIVCode.tintColor = Color(255, 255, 255, 1);
    NSDictionary *attributeDic = @{@"nClick":[UIFont systemFontOfSize:13], @"Click":@[[WPAttributedStyleAction styledActionWithAction:^{
        [self userAgreementClick:nil];
    }], [UIFont fontWithName:@"STHeitiSC-Medium" size:13]]};
    _kUITip1.attributedText = [[NSString stringWithFormat:@"<nClick>%@</nClick> <Click>%@</Click>", @"注册表示您同意遵守", @"用户协议及隐私政策"] attributedStringWithStyleBook:attributeDic];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)]];
}

- (void)tap
{
    [self.view endEditing:YES];
}

#pragma mark - callback functions 
/// 获取验证码点击事件
#pragma mark 获取验证码点击事件
-(IBAction)getVCodeClick:(id)sender {
    [self.progressHud show:YES];
    LoginHttpTool *req = [[LoginHttpTool alloc]initWithParam:[LoginHttpTool getVeryCodeWithParams:@{@"uid":_kUIAccount.text,@"flag":@"0"}]];
    [req setReturnBlock:^(NSURLSessionTask *task,NSURLResponse *response, id responseObject) {
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                [MBProgressHUD showMessage:@"验证码已发送到您手机"];
            }
        }];
    }];
}

/// 注册按钮点击事件
#pragma mark 注册按钮点击事件
-(IBAction)registerClick:(id)sender {
    [self.progressHud show:YES];
    LoginHttpTool *req = [[LoginHttpTool alloc]initWithParam:[LoginHttpTool registWithParams:@{@"uid":_kUIAccount.text,@"password":_kUIPassword.text,@"vericode":_kUIVCode.text}]];
    [req setReturnBlock:^(NSURLSessionTask *task,NSURLResponse *response, id responseObject) {
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                [MBProgressHUD showSuccess:@"注册成功" compleBlock:^{
                    LoginController *login = [[LoginController alloc]init];
                    [login loginWithParams:@{@"uid":_kUIAccount.text,@"password":_kUIPassword.text}];
                }];
            }
        }];
    }];
}

/// 用户协议及隐私政策按钮点击事件
#pragma mark 用户协议及隐私政策按钮点击事件
-(IBAction)userAgreementClick:(id)sender {
    LienceController *controller = [[LienceController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}


@end