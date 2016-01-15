//
//  LoginViewController.m
//  btWeigh
//
//  Created by mac on 15-1-4.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "LoginController.h"
#import "RegisterController.h"
#import "ResetPwdController.h"
#import "LoginHttpTool.h"
#import "AppDelegate.h"
#import "RootTabViewController.h"
#import "ALNavigationController.h"
#define GLOBAL_THIRD_OPEN 0
@interface LoginController ()

@property (strong, nonatomic) IBOutlet UIButton *yWeiboLoginBtn;
@property (strong, nonatomic) IBOutlet UIButton *yQQLoginBtn;
@property (strong, nonatomic) IBOutlet UIView *yThirdLine;

@end


@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    [self initAll];
}

#pragma mark - custom function
/// 初始化控件
- (void)initAll {
    [self removeLineOfNavigationBar];
    /*
     ========= 设置账号和密码左边的icon以及左边的边距 ======
     */
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_account"]];
    _kUIAccount.leftView = imageView;
    _kUIAccount.leftViewMode = UITextFieldViewModeAlways;
    [_kUIAccount setLeftPadding:30];
    _kUIAccount.tintColor = [UIColor whiteColor];
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_password"]];
    _kUIPassword.leftView = imageView;
    _kUIPassword.leftViewMode = UITextFieldViewModeAlways;
    [_kUIPassword setLeftPadding:30];
    _kUIPassword.tintColor = [UIColor whiteColor];
    
    // 色差
    [_kUILogin setTitleColor:ALNavBarColor forState:UIControlStateNormal];
    self.view.backgroundColor = ALNavBarColor;
    
    if (!GLOBAL_THIRD_OPEN) {
        _kUIThirdTip.hidden = YES;
        _yThirdLine.hidden = YES;
        _yWeiboLoginBtn.hidden = YES;
        _yQQLoginBtn.hidden = YES;
        _kUIThirdTip.hidden = YES;
    }
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)]];
}

- (void)tap
{
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

#pragma mark - callback function
/// 点击登录的回调函数
#pragma mark  点击登录的回调函数
- (IBAction)loginClick:(id)sender {
    [self.view endEditing:YES];
    [self loginWithParams:@{@"uid":_kUIAccount.text,@"password":_kUIPassword.text}];
}

- (void)loginWithParams:(NSDictionary *)params
{
    [self.progressHud show:YES];
    self.progressHud.labelText = @"登录中";
    LoginHttpTool *req = [[LoginHttpTool alloc]initWithParam:[LoginHttpTool loginWithParams:params]];
    [req setReturnBlock:^(NSURLSessionTask *task,NSURLResponse *response, id responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        __block  AccountModel *model = [[AccountModel alloc]init];
        model.token = httpResponse.allHeaderFields[@"cs-token"];
        model.expirytime = httpResponse.allHeaderFields[@"cs-token-expirytime"];
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                model.ID = ((NSDictionary *)data)[@"id"];
                model.phone = ((NSDictionary *)data)[@"phone"];
                model.nickName = ((NSDictionary *)data)[@"nickname"];
                [AccountTool saveAccount:model];
                ALNavigationController *nav = (ALNavigationController *)self.navigationController;
                if (nav.callBack) {
                    nav.callBack();
                    return;
                }
                RootTabViewController *ctl = [[RootTabViewController alloc]init];
                ctl.navigationController.navigationBar.hidden = YES;
                [self.navigationController pushViewController:ctl animated:YES];
            }
        }];
    }];
}

/// 微博授权登录
#pragma mark  微博授权登录
-(IBAction)weiboAuthorizeClick:(id)sender {
    [self.view endEditing:YES];
    
}
/// QQ授权登录
#pragma mark  QQ授权登录
-(IBAction)qqAuthorize:(id)sender {
    
}

/// 注册用户点击回调事件
#pragma mark  注册用户点击回调事件
- (IBAction)registerClick:(id)sender
{
    RegisterController *controller = [[RegisterController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}


///  点击忘记密码会回调这个事件
#pragma mark  点击忘记密码会回调这个事件
- (IBAction)forgetPwdClick:(id)sender
{
    ResetPwdController *controller = [[ResetPwdController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
