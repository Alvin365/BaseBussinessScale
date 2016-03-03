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
#import "BLEHttpTool.h"
#import "SetPinningController.h"
@interface BoundDeviceController ()<BleDeviceDelegate> {
    BOOL needStopScan;
    CsBtUtil *_btUtil;
    ScaleModel *_model;
    BOOL _isSure;
    BroadcastData *broadcastData;
    NSMutableSet *_broadsSet;
    NSInteger _scanCount;
    
    __weak IBOutlet NSLayoutConstraint *KUISearViewHeight;
    
    __weak IBOutlet NSLayoutConstraint *kUINoBoundBtnBottom;
    __weak IBOutlet NSLayoutConstraint *_KUISearchBottom;
    __weak IBOutlet NSLayoutConstraint *_KUIWeightTop;
    __weak IBOutlet NSLayoutConstraint *tipTop;
}

@property (weak, nonatomic) IBOutlet UIView *disFoundView;
@property (weak, nonatomic) IBOutlet UIImageView *foundImageView;

@property (nonatomic, weak) CBPeripheral *currentPeripheral;

@end

@implementation BoundDeviceController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    _btUtil.stopAdvertisementState = ![CsBtCommon getBoundMac].length;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    _btUtil.stopAdvertisementState = NO;
    [self researchClick:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeLineOfNavigationBar];
    [self datas];
    [self initAll];
    [self initConstraints];
    self.progressShow = YES;
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
    [_kUINoBound setTitle:@"先不绑定了" forState:UIControlStateNormal];
    
    [_kUIResearch setTitle:@"重新搜索" forState:UIControlStateNormal];
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
    [_kUISureBound setTitle:@"确定绑定" forState:UIControlStateNormal];
    _kUITip.text = @"已经发现体重秤，请确认秤显示的数值和下放数值一样，即可确认绑定";
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
    _kUISearchedView.backgroundColor = ALNavBarColor;
    
    [self reloadUI:NO];
}

- (void)initConstraints
{
    KUISearViewHeight.constant = 290*ALScreenScalHeight;
    tipTop.constant = 40*ALScreenScalHeight;
    _KUISearchBottom.constant = 40*ALScreenScalHeight;
    _KUIWeightTop.constant = 30*ALScreenScalHeight;
    kUINoBoundBtnBottom.constant = -100*ALScreenScalHeight;
}

- (void)datas
{
    _model = [[ScaleModel alloc]init];
    _btUtil = [CsBtUtil getInstance];
    _btUtil.delegate = self;
    [[CsBtUtil getInstance] disconnectWithBt];
    [_btUtil startScanBluetoothDevice];
    
    _broadsSet = [NSMutableSet set];
}

#pragma mark 先不绑定了按钮的点击事件
- (IBAction)noBoundClick:(id)sender
{
    // 需要根据从哪里进来跳转到不同的页面
    [self finishOperationCompletedBlock:nil];
}

/// 重新搜索按钮的点击事件
#pragma mark 重新搜索按钮的点击事件
- (IBAction)researchClick:(id)sender
{
//    [self.progressHud show:YES];
    [self reloadUI:NO];
    
    [_btUtil disconnectWithBt];
    [_btUtil startScanBluetoothDevice];
}

/// 确定绑定按钮的点击事件
#pragma mark 确定绑定按钮的点击事件
- (IBAction)sureBoundClick:(id)sender
{
    _isSure = YES;
    WS(weakSelf);
    [_btUtil stopScanBluetoothDevice];
    // 绑定时同事要保存绑定设备在广播阶段传递过来的一些配置信息
    [_btUtil setReconnectErrorBlock:^{
        [weakSelf.progressHud hide:YES];
        [MBProgressHUD showMessage:@"连接蓝牙失败，请重启蓝牙设备"];
    }];
    [_btUtil connect:_btUtil.activePeripheral];
    
    [self.progressHud show:YES];
    self.progressHud.labelText = @"绑定设备中...";
}

- (void)finishOperationCompletedBlock:(void(^)())block
{
    /**
     * 点击确认绑定 tabbar置 称重
     */
    if (_isSure) {
        self.tabBarController.selectedIndex = 0;
    }
    if (block) {
        block();
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)saveScaleInfo
{
    [_btUtil writeFrameToPeripheral:[[ResetDataReqFrame alloc] init]];
    [CsBtCommon setBoundMac:broadcastData.mac];
    [CsBtCommon setUnitDecimalPoint:broadcastData.uDecimalPoint];
    [CsBtCommon setWeightDecimalPoint:broadcastData.wDecimalPoint];
    [ScaleTool saveScale:_model];
    [CsBtUtil getInstance].state = CsScaleStateShakeHandSuccess;
}

- (void)reloadUI:(BOOL)foundBroast
{
    _disFoundView.hidden = foundBroast;
    _foundImageView.hidden = !foundBroast;
    _kUISearchedView.hidden = !foundBroast;
}

#pragma mark BleDeviceDelegate
/**
 *  发现广播数据
 *
 *  @param data 广播数据
 */
-(void)discoverBroadcastData:(BroadcastData *)data fromPeripheral:(CBPeripheral *)peripheral {
    if (_btUtil.state == CsScaleStateOpened || _btUtil.state == CsScaleStateBroadcast) {
        if (_scanCount>5) {
            [_broadsSet removeAllObjects];
        }
        if (![_broadsSet containsObject:data.mac]) {
            [_broadsSet addObject:data.mac];
            _scanCount = 0;
            broadcastData = data;
            
            [self reloadUI:YES];
            
            _kUITip.text = @"已经发现蓝牙秤，请确认秤显示的数值和下放数值一样，即可确认绑定";
            _kUIWeight.text = [NSString stringWithFormat:@"%.2f",(data.weight)];
            [_model setValuesForKeysWithDictionary:data.keyValues];
            [_btUtil stopScanBluetoothDevice];
        }else{
            _scanCount ++;
        }
    }
}

- (void)didUpdateCsScaleState:(CsScaleState)state
{
    if (state == CsScaleStateOpened){
        [self reloadUI:NO];
    }else if (state == CsScaleStateConnecting){
        self.progressHud.labelText = @"连接设备中...";
    }else if (state == CsScaleStateConnected){
        self.progressHud.labelText = @"设备已连接...";
    }
}

- (void)didHandShakeComplete:(BOOL)success
{
    WS(weakSelf);
    if (success) {
        self.progressHud.labelText = @"验证PIN码中...";
        if ([ScaleTool scale].mac.length) {
            if ([[ScaleTool scale].mac isEqualToString:broadcastData.mac]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.progressHud hide:YES];
                    [MBProgressHUD showSuccess:@"绑定成功" compleBlock:^{
                        [self finishOperationCompletedBlock:^{
                            [weakSelf saveScaleInfo];
                        }];
                    }];
                });
            }else{
                [self.progressHud hide:YES];
                showAlert(@"您已经绑定了一台秤，请到'设置--我的设备中'解除绑定后再试");
            }
            return;
        }
        BLEHttpTool *req = [[BLEHttpTool alloc]initWithParam:[BLEHttpTool boundScale:broadcastData]];
        [req setReturnBlock:^(NSURLSessionTask *task, NSURLResponse *response, id responseObject) {
            [self.progressHud hide:YES];
            [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
                if (data) {
                    [MBProgressHUD showSuccess:@"绑定成功" compleBlock:^{
                        [self finishOperationCompletedBlock:^{
                            [weakSelf saveScaleInfo];
                        }];
                    }];
                }
            }];
        }];
    }else{
        [self.progressHud hide:YES];
        [MBProgressHUD showError:@"PIN码不正确" compleBlock:^{
            SetPinningController *pin = [[SetPinningController alloc]init];
            [self.navigationController pushViewController:pin animated:YES];
        }];
    }
}

- (void)didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self.progressHud hide:YES];
    [MBProgressHUD showError:@"绑定失败"];
    
}

@end
