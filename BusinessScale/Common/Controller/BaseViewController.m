//
//  BaseViewController.m
//  BusinessScale
//
//  Created by Alvin on 15/12/15.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "BaseViewController.h"
#import "ALLogonViewController.h"
#import "ALNavigationController.h"

@interface BaseViewController ()

@property (nonatomic, copy) void(^leftBarBtnBlock)();
@property (nonatomic, copy) void(^rightBarBtnBlock)();
@property (nonatomic, copy) void(^noticeGlobalBlock)();

@end

@implementation BaseViewController

- (void)setSeverceMsgBlock:(void (^)(NSString *))severceMsgBlock
{
    _severceMsgBlock = [severceMsgBlock copy];
}

- (MBProgressHUD *)progressHud
{
    if (!_progressHud) {
        _progressHud = [[MBProgressHUD alloc]initWithView:self.view];
        [self.view addSubview:_progressHud];
    }
    return _progressHud;
}

- (PaySuccessView *)paySuccess
{
    if (!_paySuccess) {
        _paySuccess = [PaySuccessView loadXibView];
        _paySuccess.frame = [UIScreen mainScreen].bounds;
    }
    return _paySuccess;
}

- (UIView *)back
{
    if (!_back) {
        _back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
        UIImageView *lL = [[UIImageView alloc]initWithFrame:CGRectMake(0, 14, 8, 12)];
        lL.image = [UIImage imageNamed:@"icon_left.png"];
        [_back addSubview:lL];
        
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(lL.right+3, 0, 40, 40)];
        l.textColor = [UIColor whiteColor];
        l.text = @"返回";
        l.font = [UIFont systemFontOfSize:15];
        [_back addSubview:l];
        
        _back.userInteractionEnabled = YES;
        [_back addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTo)]];
    }
    return _back;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.navigationController.viewControllers.count > 1) {
        [self buildBack];
    }
    self.view.backgroundColor = backGroudColor;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(progressHide:) name:@"progressHide" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestFail:) name:@"ALWorkRequestError" object:nil];
}

- (void)buildBack
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.back];
}

- (void)backTo
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addNavLeftBarBtn:(NSString *)str selectorBlock:(void(^)())block
{
    UIImage *img = [UIImage orignImage:str];
    if (img) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    }else{
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:str style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    }
    _leftBarBtnBlock = [block copy];
}

- (void)addNavRightBarBtn:(NSString *)str selectorBlock:(void(^)())block
{
    UIImage *img = [UIImage orignImage:str];
    if (img) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:str style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    }
    _rightBarBtnBlock = [block copy];
}

- (void)leftClick
{
    if (_leftBarBtnBlock) {
        _leftBarBtnBlock();
    }
}

- (void)rightClick
{
    if (_rightBarBtnBlock) {
        _rightBarBtnBlock();
    }
}

- (void)doDatasFromNet:(NSObject *)resuilt useFulData:(void (^)(NSObject *))data
{
    if (!self.progressShow) {
        [self.progressHud hide:YES];
        self.progressHud.labelText = nil;
    }
    if ([resuilt isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)resuilt;
        if (![dic[@"code"] integerValue]) {
            if (data) {
                if (dic.count==1){
                    data(resuilt);
                }else{
                    data(dic[@"data"]);
                }
            }
        }else if ([dic[@"code"] integerValue]==2){
            YSAlertView *alert = [[YSAlertView alloc]initWithTitle:@"" message:@"请先登录" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定" click:^(NSInteger index) {
                ALLogonViewController *ctl = [[ALLogonViewController alloc]initWithNibName:@"LogonController" bundle:nil];
                ALNavigationController *nav = [[ALNavigationController alloc]initWithRootViewController:ctl];
                [self presentViewController:nav animated:YES completion:nil];
            }];
            [alert show];
        }else{
            [MBProgressHUD showError:dic[@"msg"]];
            if (self.severceMsgBlock) {
                self.severceMsgBlock(dic[@"msg"]);
            }
        }
    }else if ([resuilt isKindOfClass:[NSError class]]){
        NSError *error = (NSError *)resuilt;
        [MBProgressHUD showMessage:error.localizedDescription];
    }else{
//        [MBProgressHUD showError:@"失败"];
        data(nil);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)requestFail:(NSNotification *)notice
{
    [self.progressHud hide:YES];
    NSString *error = [notice.object localizedDescription];
    ALLog(@"request error:%@",notice);
    [MBProgressHUD showMessage:error];
}

/**
 * 去除navigationController中navgationBar中的黑线
 */
- (void)removeLineOfNavigationBar
{
    //去除navigationController中navgationBar中的黑线
    if([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }
}

- (void)noticeGlobalUnitChanged:(void (^)())block
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(noticeGlobalChanged:) name:GlobalUnitChanged object:nil];
    _noticeGlobalBlock = [block copy];
}

- (void)noticeGlobalChanged:(NSNotification *)notice
{
    _noticeGlobalBlock();
}

- (void)progressHide:(NSNotification *)notice
{
    [self.progressHud hide:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    ALLog(@"%s",__func__);
}

@end
