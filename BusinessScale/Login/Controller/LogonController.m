//
//  LogonControllerViewController.m
//  btWeigh
//
//  Created by ChipSea on 15/6/5.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "LogonController.h"
#import "RegisterController.h"
#import "LienceController.h"
#import "LoginController.h"
#import "RootTabViewController.h"
@interface LogonController ()

@end

@implementation LogonController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initAll];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark - custom functions
/// 初始化
#pragma mark 初始化
-(void)initAll {
    
    _kUILogonTip.text = @"登录则表示您同意遵守OKOK蓝牙秤的";
    // 由于xib有色差，所以通过代码设置颜色
    self.view.backgroundColor = ALNavBarColor;
    [_kUIRegister setTitleColor:ALNavBarColor forState:UIControlStateNormal];
    // 国际化
    [_kUITourist setTitle:@"访客模式" forState:UIControlStateNormal];
    [_kUIRegister setTitle: @"注册" forState:UIControlStateNormal];
    [_kUILogin setTitle:@"登录" forState:UIControlStateNormal];
    
    [_kUIAgreementLicense setTitle: @"用户协议及隐私政策" forState:UIControlStateNormal];
    
    [self removeLineOfNavigationBar];
}


#pragma mark - callback functions
/// 访客模式点击事件
#pragma mark - 访客模式点击事件
-(IBAction)touristModeClick:(id)sender {
    RootTabViewController *ctl = [[RootTabViewController alloc]init];
    ctl.navigationController.navigationBar.hidden = YES;
    [self.navigationController pushViewController:ctl animated:YES];
}

/// 注册点击事件
#pragma mark - 注册点击事件
-(IBAction)registerClick:(id)sender {
    RegisterController *controller = [[RegisterController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

/// 登录点击事件
#pragma mark - 登录点击事件
-(IBAction)loginClick:(id)sender {
    LoginController *controller = [[LoginController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

/// 用户协议及隐私政策点击事件
#pragma mark - 用户协议及隐私政策点击事件
-(IBAction)userAgreementClick:(id)sender {
    LienceController *controller = [[LienceController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
