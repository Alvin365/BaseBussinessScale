//
//  BoundDeviceController2.m
//  btWeigh
//
//  Created by ChipSea on 15/6/6.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "BoundDeviceController.h"
#import "LogonController.h"
#import "MyDeviceController.h"
#import <Commercial-Bluetooth/CsBtUtil.h>
#import "ScaleTool.h"
#import "ALNavigationController.h"
@interface BoundDeviceController ()<BleDeviceDelegate> {
    BOOL needStopScan;
    CsBtUtil *_btUtil;
    ScaleModel *_model;
    BOOL _isSure;
    BroadcastData *broadcastData;
    
    __weak IBOutlet NSLayoutConstraint *KUISearViewHeight;
    
    __weak IBOutlet NSLayoutConstraint *_KUISearchBottom;
    __weak IBOutlet NSLayoutConstraint *_KUIWeightTop;
    __weak IBOutlet NSLayoutConstraint *KUINoBoundTop;
    __weak IBOutlet NSLayoutConstraint *tipTop;
}

@end

@implementation BoundDeviceController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeLineOfNavigationBar];
    [self initAll];
    [self initConstraints];
    _model = [[ScaleModel alloc]init];
    _btUtil = [CsBtUtil getInstance];
    _btUtil.delegate = self;
//    [self.progressHud show:YES];
//    self.progressHud.labelText = @"搜索中...";
    [_btUtil startScanBluetoothDevice];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if (_btUtil.haveFoundDevices) {
//            [MBProgressHUD showError:@"附近没有蓝牙设备"];
//            [self.progressHud hide:YES];
//        }
//    });
}

#pragma mark - custom functions
/// 初始化
#pragma mark 初始化
-(void) initAll {
    // 国际化
    _kUINoBound.layer.cornerRadius = 25;
    _kUINoBound.layer.masksToBounds = YES;
    _kUINoBound.layer.borderColor = ALLightTextColor.CGColor;
    _kUINoBound.layer.borderWidth = 0.7;
    [_kUINoBound setTitleColor:ALLightTextColor forState:UIControlStateNormal];
    [_kUINoBound setTitle:DPLocalizedString(@"not_bind_now", @"先不绑定了") forState:UIControlStateNormal];
    
    [_kUIResearch setTitle:DPLocalizedString(@"research", @"重新搜索") forState:UIControlStateNormal];
    _kUISearchedView.backgroundColor = ALNavBarColor;
    _kUIResearch.backgroundColor = [UIColor clearColor];
    [_kUIResearch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _kUIResearch.layer.cornerRadius = 20;
    _kUIResearch.layer.masksToBounds = YES;
    _kUIResearch.layer.borderColor = [UIColor whiteColor].CGColor;
    _kUIResearch.layer.borderWidth = 0.7;
    _kUISureBound.backgroundColor = [UIColor whiteColor];
    [_kUISureBound setTitleColor:ALNavBarColor forState:UIControlStateNormal];
    
    
    _kUISureBound.layer.cornerRadius = 20;
    _kUISureBound.layer.masksToBounds = YES;
    [_kUISureBound setTitle:DPLocalizedString(@"sure_bind", @"确定绑定") forState:UIControlStateNormal];
    _kUITip.text = DPLocalizedString(@"bind_tip", @"已经发现体重秤，请确认秤显示的数值和下放数值一样，即可确认绑定");
    NSString *frmtStr = @"open_ble_2";
    if ([[ALCommonTool getPreferredLanguage] isEqualToString:@"en"]) {
        frmtStr = [frmtStr stringByAppendingString:@"_en"];
//        _kUIWeight.font = [UIFont fontWithName:GLOBAL_EN_FONT_BOLD2 size:36];
//        _kUIUnit.font = [UIFont fontWithName:GLOBAL_EN_FONT_BOLD size:16];
    }
    if (screenHeight==480) {
        frmtStr = [frmtStr stringByAppendingString:@"_4s"];
    }
//    _kUIBackground.image = [UIImage imageNamed:frmtStr];
    
    _kUINoBound.hidden = NO;
    _kUISearchedView.hidden = NO;
    _kUISearchedView.backgroundColor = [UIColor whiteColor];
    _kUIWeight.hidden = _kUITip.hidden = _kUIResearch.hidden = _kUISureBound.hidden = YES;
    
}

- (void)initConstraints
{
    KUISearViewHeight.constant = 290*ALScreenScalHeight;
    tipTop.constant = 40*ALScreenScalHeight;
    _KUISearchBottom.constant = 40*ALScreenScalHeight;
    _KUIWeightTop.constant = 30*ALScreenScalHeight;
    KUINoBoundTop.constant = 40*ALScreenScalHeight;
}

#pragma mark 先不绑定了按钮的点击事件
- (IBAction)noBoundClick:(id)sender
{
    // 需要根据从哪里进来跳转到不同的页面
    [self finishOperation];
}

/// 重新搜索按钮的点击事件
#pragma mark 重新搜索按钮的点击事件
- (IBAction)researchClick:(id)sender
{
//    [self.progressHud show:YES];
    _kUIWeight.hidden = _kUITip.hidden = _kUIResearch.hidden = _kUISureBound.hidden = YES;
    _kUINoBound.hidden = NO;
    _kUISearchedView.backgroundColor = [UIColor whiteColor];
    [_btUtil disconnectWithBt];
    [_btUtil startScanBluetoothDevice];
}

/// 确定绑定按钮的点击事件
#pragma mark 确定绑定按钮的点击事件
- (IBAction)sureBoundClick:(id)sender
{
    _isSure = YES;
    
    [_btUtil connect:_btUtil.activePeripheral];
    [_btUtil stopScanBluetoothDevice];
    // 绑定时同事要保存绑定设备在广播阶段传递过来的一些配置信息
    [CsBtCommon setBoundMac:broadcastData.mac];
    [CsBtCommon setUnitDecimalPoint:broadcastData.uDecimalPoint];
    [CsBtCommon setWeightDecimalPoint:broadcastData.wDecimalPoint];
    [ScaleTool saveScale:_model];
    [self.progressHud show:YES];
    self.progressHud.labelText = @"绑定设备中...";
}

- (void)finishOperation
{
    /**
     * 第一次启动事件
     */
    ALNavigationController *nav = (ALNavigationController *)self.navigationController;
    if (nav.callBack) {
        nav.callBack();
        return;
    }
    
    /**
     * 点击确认绑定 tabbar置 称重
     */
    if (_isSure) {
        self.tabBarController.selectedIndex = 0;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark BleDeviceDelegate

/**
 *  发现广播数据
 *
 *  @param data 广播数据
 */
-(void)discoverBroadcastData:(BroadcastData *)data fromPeripheral:(CBPeripheral *)peripheral {
    if (_btUtil.state == CsScaleStateOpened || _btUtil.state == CsScaleStateBroadcast) {
         broadcastData = data;
//        [self.progressHud hide:YES];
//        [_btUtil stopScanBluetoothDevice];
        _kUISearchedView.hidden = NO;
        _kUINoBound.hidden = YES;
        _kUIWeight.hidden = _kUITip.hidden = _kUIResearch.hidden = _kUISureBound.hidden = NO;
        _kUISearchedView.backgroundColor = ALNavBarColor;
        _kUITip.text = DPLocalizedString(@"bind_tip", @"已经发现蓝牙秤，请确认秤显示的数值和下放数值一样，即可确认绑定");
        _kUIWeight.text = [NSString stringWithFormat:@"%i",(int)(data.weight*1000)];
        [_model setValuesForKeysWithDictionary:data.keyValues];
    }
   
}
//- (void)connectedPeripheral:(CBPeripheral *)peripheral
//{
//    
//}
- (void)didHandShakeComplete:(BOOL)success
{
    [self.progressHud hide:YES];
    if (success) {
        [MBProgressHUD showSuccess:@"绑定成功" compleBlock:^{
            [self finishOperation];
        }];
    }else{
        [MBProgressHUD showError:@"绑定失败"];
    }
}

- (void)didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self.progressHud hide:YES];
    [MBProgressHUD showError:@"绑定失败"];
}

@end
