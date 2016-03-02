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
#import "LoginBussiness.h"
@interface RegisterController ()
{
    NSTimer *_timer;
}
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
    _kUIGetVCode.layer.cornerRadius = 5;
    _kUIGetVCode.layer.masksToBounds = YES;
    _kUIGetVCode.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *attributeDic = @{@"nClick":[UIFont systemFontOfSize:13], @"Click":@[[WPAttributedStyleAction styledActionWithAction:^{
        [self userAgreementClick:nil];
    }], [UIFont fontWithName:@"STHeitiSC-Medium" size:13]]};
    _kUITip1.attributedText = [[NSString stringWithFormat:@"<nClick>%@</nClick> <Click>%@</Click>", @"注册表示您同意遵守", @"用户协议及隐私政策"] attributedStringWithStyleBook:attributeDic];
    _kUITip1.textColor = [UIColor whiteColor];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)]];
    
    [self addTimer];
    [_timer setFireDate:[NSDate distantFuture]];
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

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)tap
{
    [self.view endEditing:YES];
}

#pragma mark - callback functions 
/// 获取验证码点击事件
#pragma mark 获取验证码点击事件
-(IBAction)getVCodeClick:(id)sender {
    if ([sender tag]>1) {
        [MBProgressHUD showMessage:@"验证码已经发送，请稍后"];
        return;
    }
    if (![ALCommonTool verifyMobilePhone:self.kUIAccount.text]) {
        [MBProgressHUD showMessage:@"手机号码不正确"];
        return;
    }
    [self.progressHud show:YES];
    LoginHttpTool *req = [[LoginHttpTool alloc]initWithParam:[LoginHttpTool getVeryCodeWithParams:@{@"uid":_kUIAccount.text,@"flag":@"0"}]];
    [req setReturnBlock:^(NSURLSessionTask *task,NSURLResponse *response, id responseObject) {
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                _kUIGetVCode.tag = 120;
                [_timer setFireDate:[NSDate date]];
                [MBProgressHUD showMessage:@"验证码已发送到您手机"];
            }
        }];
    }];
//    WS(weakSelf);
//    __weak NSTimer *weakTimer = _timer;
//    [self setSeverceMsgBlock:^(NSString *msg) {
//        [weakTimer setFireDate:[NSDate distantFuture]];
//        [weakSelf.kUIGetVCode setTitle:@"获取验证码" forState:UIControlStateNormal];
//        weakSelf.kUIGetVCode.titleLabel.text = @"获取验证码";
//    }];
}

/// 注册按钮点击事件
#pragma mark 注册按钮点击事件
-(IBAction)registerClick:(id)sender {
    if (![ALCommonTool verifyMobilePhone:self.kUIAccount.text]) {
        [MBProgressHUD showMessage:@"手机号码不正确"];
        return;
    }
    if (!self.kUIPassword.text.length) {
        [MBProgressHUD showMessage:@"请输入密码"];
        return;
    }
    if (!self.kUIVCode.text.length) {
        [MBProgressHUD showMessage:@"请输入验证码"];
        return;
    }
    [self.progressHud show:YES];
    LoginHttpTool *req = [[LoginHttpTool alloc]initWithParam:[LoginHttpTool registWithParams:@{@"uid":_kUIAccount.text,@"password":_kUIPassword.text,@"vericode":_kUIVCode.text}]];
    [req setReturnBlock:^(NSURLSessionTask *task,NSURLResponse *response, id responseObject) {
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                [MBProgressHUD showSuccess:@"注册成功" compleBlock:^{
                    [LoginBussiness loginWithParams:@{@"uid":_kUIAccount.text,@"password":_kUIPassword.text} completedBlock:^{
                        [[NSUserDefaults standardUserDefaults]setObject:_kUIPassword.text forKey:loginPassWord];
                        [[NSUserDefaults standardUserDefaults]setObject:_kUIAccount.text forKey:loginAccount];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        if ([Reachability shareReachAbilty].currentReachabilityStatus == ReachableViaWiFi) {
                            [[GlobalBussiness shareBussiness]downLoadSaleRecords];
                        }
                        [LoginBussiness getGoodsListFromSeverce];
                        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                        RootTabViewController *root = (RootTabViewController *)delegate.window.rootViewController;
                        root.selectedIndex = 0;
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
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