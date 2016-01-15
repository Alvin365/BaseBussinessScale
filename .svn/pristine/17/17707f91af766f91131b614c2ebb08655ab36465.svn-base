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
    
    __weak IBOutlet NSLayoutConstraint *KUISearViewHeight;
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
    _model = [[ScaleModel alloc]init];
    _btUtil = [CsBtUtil getInstance];
    _btUtil.delegate = self;
    [self.progressHud show:YES];
    [_btUtil startScanBluetoothDevice];
}

#pragma mark - custom functions
/// 初始化
#pragma mark 初始化
-(void) initAll {
    // 国际化
    _kUINoBound.layer.cornerRadius = 5;
    _kUINoBound.layer.masksToBounds = YES;
    [_kUINoBound setTitle:DPLocalizedString(@"not_bind_now", @"先不绑定了") forState:UIControlStateNormal];
    [_kUIResearch setTitle:DPLocalizedString(@"research", @"重新搜索") forState:UIControlStateNormal];
    _kUIResearch.layer.cornerRadius = 5;
    _kUIResearch.layer.masksToBounds = YES;
    _kUISureBound.layer.cornerRadius = 5;
    _kUISureBound.layer.masksToBounds = YES;
    [_kUISureBound setTitle:DPLocalizedString(@"sure_bind", @"确定绑定") forState:UIControlStateNormal];
    _kUITip.text = DPLocalizedString(@"bind_tip", @"已经发现体重秤，请确认秤显示的数值和下放数值一样，即可确认绑定");
    // 色差
    [_kUINoBound setTitleColor:ALNavBarColor forState:UIControlStateNormal];
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
    _kUIWeight.hidden = _kUITip.hidden = _kUIResearch.hidden = _kUISureBound.hidden = YES;
    KUISearViewHeight.constant = 270*ALScreenScalHeight;
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
    [self.progressHud show:YES];
    _kUIWeight.hidden = _kUITip.hidden = _kUIResearch.hidden = _kUISureBound.hidden = YES;
    _kUINoBound.hidden = NO;
    [_btUtil disconnectWithBt];
    [_btUtil startScanBluetoothDevice];
}

/// 确定绑定按钮的点击事件
#pragma mark 确定绑定按钮的点击事件
- (IBAction)sureBoundClick:(id)sender
{
    [_btUtil connect:_btUtil.activePeripheral];
    [self.progressHud show:YES];
    self.progressHud.labelText = @"绑定设备中...";
}

- (void)finishOperation
{
    ALNavigationController *nav = (ALNavigationController *)self.navigationController;
    if (nav.callBack) {
        nav.callBack();
        return;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark BleDeviceDelegate
/**
 *  发现广播数据
 *
 *  @param data 广播数据
 */
- (void)discoverBroadcastData:(BroadcastData *)data fromPeripheral:(CBPeripheral *)peripheral
{
    if (_btUtil.state == CsScaleStateOpened || _btUtil.state == CsScaleStateBroadcast) {
        [self.progressHud hide:YES];
        [_btUtil stopScanBluetoothDevice];
        _kUISearchedView.hidden = NO;
        _kUINoBound.hidden = YES;
        _kUIWeight.hidden = _kUITip.hidden = _kUIResearch.hidden = _kUISureBound.hidden = NO;
        _kUITip.text = DPLocalizedString(@"bind_tip", @"已经发现蓝牙秤，请确认秤显示的数值和下放数值一样，即可确认绑定");
        _kUIWeight.text = [NSString stringWithFormat:@"%ig",(int)(data.weight*1000)];
        [_model setValuesForKeysWithDictionary:data.keyValues];
    }
}

- (void)connectedPeripheral:(CBPeripheral *)peripheral
{
    [self.progressHud hide:YES];
    [MBProgressHUD showSuccess:@"绑定成功" compleBlock:^{
        [ScaleTool saveScale:_model];
        [self finishOperation];
    }];
}

- (void)didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self.progressHud hide:YES];
    [MBProgressHUD showError:@"绑定失败"];
}

/**
 *  蓝牙状态发生变化的回调
 *
 *  @param state 蓝牙状态
 */
- (void)didUpdateCsScaleState:(CsScaleState)state
{
    switch (state) {
        case CsScaleStateOpened:
//            [_btUtil->_manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
            break;
        case CsScaleStateClosed:
            showAlert(@"请先打开蓝牙");
            break;
        case CsScaleStateCalculating:
            break;
        case CsScaleStateWaitCalculat:
            break;
        case CsScaleStateConnected:
            [_btUtil stopScanBluetoothDevice];
            break;
        case CsScaleStateConnecting:
            break;
        case CsScaleStateBroadcast:
            break;
    }
}


@end
