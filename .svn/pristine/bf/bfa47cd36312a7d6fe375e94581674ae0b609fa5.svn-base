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
@interface MyDeviceController ()

@end

@implementation MyDeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeLineOfNavigationBar];
    [self initAll];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = DPLocalizedString(@"my_scale", @"我的设备");
}

#pragma mark - custom functions
/// 初始化
#pragma mark 初始化
-(void) initAll {
    ALLog(@"MyDeviceController -> initAll");
    //国际化
    [_kUIToKnowOkOk setTitle:DPLocalizedString(@"see_whats_okok_bluetooth_scale", @"了解OKOK蓝牙秤") forState:UIControlStateNormal];
    [_kUIBoundBtn setTitle:DPLocalizedString(@"bind_okok_bluetooth_scale", @"绑定OKOK蓝牙秤") forState:UIControlStateNormal];
    _kUIUnBound.text = DPLocalizedString(@"unbound", @"解除绑定");
    _kUIDeviceInfo.text = DPLocalizedString(@"scale_info", @"设备信息");
    
    //色差
    _kUILine1.backgroundColor = separateLabelColor;
    _kUILine2.backgroundColor = separateLabelColor;
//    _kUIUnBound.textColor = BLACK_COLOR_FONT;
//    _kUIDeviceInfo.textColor = BLACK_COLOR_FONT;
    _kUIDeviceInfoBg.backgroundColor = ALNavBarColor;
//    [_kUIToKnowOkOk setTitleColor:BLACK_COLOR_FONT forState:UIControlStateNormal];
    [_kUIBoundBtn setTitleColor:ALNavBarColor forState:UIControlStateNormal];
    //设置分割线高度
    _kUILine1.height = ALSeparaLineHeight;
    _kUILine2.height = ALSeparaLineHeight;
    _kUIBoundBtn.layer.borderWidth = 1;
    _kUIBoundBtn.layer.borderColor = ALNavBarColor.CGColor;
    [_kUIToKnowOkOk setTitleColor:Color(0, 0, 0, .6) forState:UIControlStateNormal];
    if ([[ALCommonTool getPreferredLanguage] isEqualToString:@"en"]) {
//        _kUIToKnowOkOk.titleLabel.font = [UIFont fontWithName:GLOBAL_EN_FONT_NORMAL size:13];
//        _kUIBoundBtn.titleLabel.font = [UIFont fontWithName:GLOBAL_EN_FONT_NORMAL size:14];
    }
//    //!!!: DEBUG 测试已经绑定设备的语句
//    ScaleInfo *testScaleInfo = [[ScaleInfo alloc] init];
//    testScaleInfo.mac = @"123";
//    testScaleInfo.product_id = 1441184528;
//    testScaleInfo.type_id = 1;
//    [UserDefaultUtil setCurScale:testScaleInfo];
}

#pragma mark - callback functions
/// 解除绑定点击事件
#pragma 解除绑定点击事件
-(IBAction)unboundDeviceClick:(id)sender {
    [LocalDataTool removeDocumAtPath:@"scale.data"];
    [[CsBtUtil getInstance] disconnectWithBt];
    [[CsBtUtil getInstance]stopScanBluetoothDevice];
    [MBProgressHUD showSuccess:@"解绑成功" compleBlock:^{
        [self.navigationController popToRootViewControllerAnimated:YES];
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
//    UIViewController *controller;
//    if ([CsBtUtil getInstance].state != CsScaleStateClosed) {
//        controller = [[BoundDeviceController alloc] init];
//    } else {
//        controller = [[OpenBleController alloc] init];
//    }
//    [self.navigationController pushViewController:controller animated:YES];
}

@end
