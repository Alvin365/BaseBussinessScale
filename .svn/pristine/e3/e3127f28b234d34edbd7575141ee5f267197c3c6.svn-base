//
//  MyDeviceController.m
//  btWeigh
//
//  Created by mac on 15/6/2.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "MyDeviceController.h"
#import "OpenBleController.h"
#import "DeviceInformationController.h"
#import "BoundDeviceController.h"
#import <Commercial-Bluetooth/CsBtUtil.h>
#import "BLEHttpTool.h"
#import "BlueToothBussiness.h"
#import "SetPinningController.h"
@interface MyDeviceController ()
@property (weak, nonatomic) IBOutlet UIView *sepLine;

@end

@implementation MyDeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeLineOfNavigationBar];
    [self initAll];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"我的设备";
}

#pragma mark - custom functions
/// 初始化
#pragma mark 初始化
-(void) initAll {
    //国际化
    [_kUIToKnowOkOk setTitle:@"了解OKOK商用秤" forState:UIControlStateNormal];
    [_kUIBoundBtn setTitle:@"绑定OKOK商用秤" forState:UIControlStateNormal];
    _kUIUnBound.text = @"解除绑定";
    _kUIDeviceInfo.text = @"设备信息";
    
    //色差
    _kUILine1.backgroundColor = separateLabelColor;
    _kUILine2.backgroundColor = separateLabelColor;
    _sepLine.backgroundColor = separateLabelColor;
    _kUIUnBound.textColor = ALTextColor;
    _kUIDeviceInfo.textColor = ALTextColor;
    _kUIDeviceInfoBg.backgroundColor = [UIColor whiteColor];
    [_kUIToKnowOkOk setTitleColor:ALLightTextColor forState:UIControlStateNormal];
    [_kUIBoundBtn setTitleColor:ALNavBarColor forState:UIControlStateNormal];
    //设置分割线高度
    _kUILine1.height = ALSeparaLineHeight;
    _kUILine2.height = ALSeparaLineHeight;
    _sepLine.height = ALSeparaLineHeight;
    _kUIBoundBtn.layer.borderWidth = 1;
    _kUIBoundBtn.layer.borderColor = ALNavBarColor.CGColor;
    _kUIBoundBtn.layer.cornerRadius = 5;
    _kUIBoundBtn.layer.masksToBounds = YES;
    
    _kUINoboundView.hidden = [ScaleTool scale].mac.length;
    ALLog(@"scaleInfo = %@",[ScaleTool scale]);
    _kUIBoundView.hidden = ![ScaleTool scale].mac.length;
}


#pragma mark - callback functions
/// 解除绑定点击事件
#pragma 解除绑定点击事件
-(IBAction)unboundDeviceClick:(id)sender {
    if (![self judgeCanUpLoad]) return;
    [self.progressHud show:YES];
    BLEHttpTool *req = [[BLEHttpTool alloc]initWithParam:[BLEHttpTool deleteScale]];
    [req setReturnBlock:^(NSURLSessionTask *task, NSURLResponse *response, id responseObject) {
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                [BlueToothBussiness removeBoundToBleUpdateSychroLogoCompletedBlock:^{
                    [MBProgressHUD showSuccess:@"解绑成功" compleBlock:^{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }];
                }];
            }
        }];
    }];
}

-(IBAction)deviceInfoClick:(id)sender {
    ALLog(@"MyDeviceController -> deviceInfoClick");
    DeviceInformationController *controller = [[DeviceInformationController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

-(IBAction)toKnowOkOkClick:(id)sender {
   
}

-(IBAction)boundClick:(id)sender {
    ALLog(@"MyDeviceController -> boundClick");
//    [self.navigationController setNavigationBarHidden:YES];
    UIViewController *controller;
    if ([CsBtUtil getInstance].state != CsScaleStateClosed) {
//        if([CsBtCommon getPin].length){
            controller = [[BoundDeviceController alloc]init];
//        }else{
//            controller = [[SetPinningController alloc]init];
//            ((SetPinningController *)controller).isPush = YES;
//        }
    } else {
        controller = [[OpenBleController alloc] init];
    }
    [self.navigationController pushViewController:controller animated:YES];
}

- (BOOL)judgeCanUpLoad
{
    BOOL b = YES;
    if ([Reachability shareReachAbilty].currentReachabilityStatus == NotReachable) {
        [MBProgressHUD showError:@"当前网络不好，请重选网络再试"];
        b = NO;
    }
    return b;
}

@end
