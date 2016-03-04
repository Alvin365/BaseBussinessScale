//
//  WeighingViewController.m
//  BusinessScaleBase
//
//  Created by Alvin on 15/12/15.
//  Copyright © 2015年 chipsea. All rights reserved.
//
#import "WeighingViewController.h"
#import "GoodsSwapCell.h"
#import "PalletViewController.h"
#import "ALNavigationController.h"
#import "GoodsListController.h"
#import "PayWaySelectView.h"
#import "WeightNoDatasView.h"
#import "WeightHttpTool.h"
#import "LoginHttpTool.h"
#import "WeightBussiness.h"
#import "LocalDataTool.h"
#import <Commercial-Bluetooth/CsBtUtil.h>
#import "OpenBleController.h"
#import "GoodsListHttpTool.h"
#import "BoundDeviceController.h"
#import "QuardCodeView.h"
#import "SettingBussiness.h"
#import "SetPinningController.h"
#import "BLEHttpTool.h"
#import "BlueToothBar.h"

#define currentPalletList [NSString stringWithFormat:@"currentPalletList%@",[AccountTool account].ID]
@interface WeighingViewController ()<UITableViewDataSource,UITableViewDelegate,BleDeviceDelegate>
{
    NSString *code_url;
    CsBtUtil *_btUtil;
    NSMutableDictionary *_paramsDic;
    NSString *po_uuid;
}
@property (weak, nonatomic) IBOutlet UIView *SepView;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel *unitL;
@property (weak, nonatomic) IBOutlet UIImageView *goodImage;
@property (weak, nonatomic) IBOutlet UIButton *putInBtn;
@property (weak, nonatomic) IBOutlet UIButton *payMoneyBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *weightL;

@property (nonatomic, strong) PayWaySelectView *paySelectView;
@property (nonatomic, strong) WeightNoDatasView *noDatasView;
@property (nonatomic, strong) QuardCodeView *qrCodeView;

#pragma mark - layoutConstraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *putInTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *putInHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *putInWith;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sepTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sepHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodImageTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsImageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsImageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsNameHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weightLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payMoneyTailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weightTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodImageLeading;
@property (nonatomic, strong) BlueToothBar *rightBar;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CGFloat weight;
@property (nonatomic, strong) SaleItem *item;

@end

@implementation WeighingViewController
#pragma mark - -getter
- (UIView *)rightBar
{
    WS(weakSelf);
    if (!_rightBar) {
        _rightBar = [[BlueToothBar alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        _rightBar.callBack = ^{
            [weakSelf connectToBLE];
        };
    }
    return _rightBar;
}

- (MBProgressHUD *)progressHud
{
    if (!_progressHud) {
        _progressHud = [[MBProgressHUD alloc]initWithView:self.view];
        [[[[UIApplication sharedApplication] windows] lastObject] addSubview:_progressHud];
    }
    return _progressHud;
}

- (PayWaySelectView *)paySelectView
{
    if (!_paySelectView) {
        WS(weakSelf);
        _paySelectView = [PayWaySelectView loadXibView];
        _paySelectView.frame = [UIScreen mainScreen].bounds;
        _paySelectView.callBack = ^(PayWayType type){
            if (weakSelf.dataArray.count==0) {
                [MBProgressHUD showMessage:@"当前托盘中还没物品哦~"];
            }else{
                if ([weakSelf.paySelectView.realPriceTextField.inputField.text floatValue]<=0) {
                    [MBProgressHUD showMessage:@"请输入折扣后的价格"];
                    return ;
                }
                [weakSelf uploadRecordsWithType:type];
            }
        };
    }
    return _paySelectView;
}

- (QuardCodeView *)qrCodeView
{
    if (!_qrCodeView) {
        _qrCodeView = [QuardCodeView loadXibView];
        _qrCodeView.frame = [UIScreen mainScreen].bounds;
    }
    return _qrCodeView;
}

- (WeightNoDatasView *)noDatasView
{
    if (!_noDatasView) {
        _noDatasView = [WeightNoDatasView loadXibView];
        _noDatasView.frame = self.view.bounds;
    }
    return _noDatasView;
}
#pragma mark - -viewDidLoad
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.rightBar.state = _btUtil.state;
    _btUtil.delegate = self;
    if (_btUtil.state < CsScaleStateConnected) {
        _btUtil.stopAdvertisementState = ![CsBtCommon getBoundMac].length;
        [_btUtil startScanBluetoothDevice];
    }
    [self datas];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _btUtil = [CsBtUtil getInstance];
    _btUtil.delegate = self;
    [self initFromXib];
    [self buildNavBarItems];
    [self datas];
}

- (void)initFromXib
{
    CGFloat scale = 1.0f; // 调整4s的间距用
    self.putInTop.constant = 30*ALScreenScalHeight*scale;
    self.putInWith.constant = 120*ALScreenScalWidth;
    self.putInHeight.constant = 55*ALScreenScalWidth;
    self.weightLeading.constant = 42.5*ALScreenScalWidth;
    self.goodImageTop.constant = 30*ALScreenScalHeight*scale;
    self.goodsImageWidth.constant = 65*ALScreenScalWidth;
    self.goodsImageHeight.constant = 65*ALScreenScalWidth;
//    self.goodsNameHeight.constant = 40;
    self.sepTop.constant = 30*ALScreenScalHeight*scale;
    self.sepHeight.constant = 60*ALScreenScalHeight*scale;
    self.payMoneyTailing.constant = 42.5*ALScreenScalWidth;
    self.weightTop.constant = 20*ALScreenScalHeight*scale;
    
    /** 图片和价格居中显示*/
    self.priceL.font = [UIFont systemFontOfSize:50*ALScreenScalWidth];
    CGFloat width = [self.priceL.text bundingWithSize:CGSizeMake(screenWidth, 50*ALScreenScalWidth) Font:50*ALScreenScalWidth].width;
    width = screenWidth-(width+self.goodsImageWidth.constant+32);
    self.goodImageLeading.constant = width/2.0f;
    
    _goodImage.layer.cornerRadius = 32.5f*ALScreenScalWidth;
    _goodImage.layer.masksToBounds = YES;
    _unitL.textColor = ALTextColor;
    _priceL.textColor = ALTextColor;
    
    UIColor *color = ALLightTextColor;
    _weightL.textColor = color;
    _weightL.layer.borderColor = color.CGColor;
    _weightL.layer.borderWidth = 0.7;
    _weightL.layer.cornerRadius = 5;
    _weightL.clipsToBounds = YES;
    
    _putInBtn.layer.cornerRadius = (55*ALScreenScalWidth)/2.0f;
    _putInBtn.backgroundColor = [UIColor colorWithHexString:@"90bf46"];
    _payMoneyBtn.layer.cornerRadius = (55*ALScreenScalWidth)/2.0f;
    _payMoneyBtn.backgroundColor = ALRedColor;
    _payMoneyBtn.layer.masksToBounds = YES;
    _putInBtn.layer.masksToBounds = YES;
    
    _totalPrice.backgroundColor = [UIColor clearColor];
    _totalPrice.attributedText = [ALCommonTool setAttrbute:@"总价：" andAttribute:@"26.4元" Color1:ALTextColor Color2:ALTextColor Font1:15 Font2:22];
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.delegate = self;
    _table.dataSource = self;
    
    _SepView.backgroundColor = backGroudColor;
    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 0.5)];
    l.backgroundColor = separateLabelColor;
    [_SepView addSubview:l];
}

- (void)buildNavBarItems
{
    WS(weakSelf);
    self.rightBar.state = _btUtil.state;
    self.navigationItem.title = @"OKOK计量";
    [self addNavLeftBarBtn:@"进入托盘" selectorBlock:^{
        PalletViewController *pctl = [[PalletViewController alloc]init];
        [weakSelf.navigationController pushViewController:pctl animated:YES];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBar];
}

#pragma mark - -actions
- (IBAction)btnClick:(id)sender
{
    if ([sender tag]) {
        [self.paySelectView showAnimate:YES];
    }else{
        [self saveBackupPallet];
    }
}

- (void)uploadRecordsWithType:(PayWayType)type
{
    NSString *payWay = nil;
    if (type == PayWayTypeCrash) {
        payWay = @"cash";
    }else if (type == PayWayTypeWechatPay){
        payWay = @"weixin";
        self.paySelectView.payWayImageView.image = [UIImage imageNamed:@"weixin6.png"];
    }else if(type == PayWayTypeAlipay){
        payWay = @"alipay";
        self.paySelectView.payWayImageView.image = [UIImage imageNamed:@"支付宝11.png"];
    }else if (type == PayWayTypeOnline){
        payWay = @"online";
    }
    
    NSInteger paid_fee = (NSInteger)([self.paySelectView.realPriceTextField.inputField.text floatValue]*100.0f+0.5);
    NSInteger totals_fee = (NSInteger)([[[self.paySelectView.priceL.text componentsSeparatedByString:@"￥"] lastObject] floatValue]*100.0f+0.5);
    if (paid_fee > totals_fee) {
        [MBProgressHUD showMessage:@"折扣价不能大于总价，请修改价格"];
        return;
    }
    [self.progressHud show:YES];
    
    NSDictionary *params = [WeightBussiness upLoadDatasTransfer:totals_fee payFee:paid_fee datas:_dataArray];
    [_paramsDic removeAllObjects];
    [_paramsDic addEntriesFromDictionary:params];
    [_paramsDic setObject:payWay forKey:@"payment_type"];
    
    if ([Reachability shareReachAbilty].currentReachabilityStatus == NotReachable) {
        if (type == PayWayTypeCrash) {
            [self paySuccessEventCompletedBlock:nil];
        }else{
            [MBProgressHUD showError:@"当前网络不好，不能使用微信和支付宝支付"];
        }
        return;
    }
    
    [self upLoadRecordsWithParams:_paramsDic completedBlock:^(NSObject *data){
        po_uuid = ((NSDictionary *)data)[@"po_uuid"];
        if (type!=PayWayTypeCrash) {
            NSDictionary *dic = (NSDictionary *)data;
            NSString *alipayCode = dic[@"alipay"][@"code_url"];
            NSString *weixinPayCode = dic[@"weixin"][@"code_url"];
            code_url = alipayCode?alipayCode:weixinPayCode;
            if (!code_url) {
                return;
            }
            [self.paySelectView showSuccessQrImage:code_url];
            self.paySelectView.priceL.text = [NSString stringWithFormat:@"结算价：￥%@",self.paySelectView.realPriceTextField.inputField.text];
            [self getPoStatusWithOrderID:po_uuid];
        }else{
            [self paySuccessEventCompletedBlock:^{
                [LocalDataTool removeDocumAtPath:currentPalletList];
            }];
        }
    }];
}

- (void)connectToBLE
{
    if (_btUtil.state != CsScaleStateClosed) {
        if ([CsBtCommon getPin].length) {
            UIViewController *controller = [[BoundDeviceController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            SetPinningController *pin = [[SetPinningController alloc]init];
            pin.title = @"PIN码设置";
            pin.isPush = YES;
            [self.navigationController pushViewController:pin animated:YES];
        }
        return;
    }
    OpenBleController *open = [[OpenBleController alloc]init];
    [self.navigationController pushViewController:open animated:YES];
}

#pragma mark - -datas
- (void)datas
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    if (!_item) {
        _item = [[SaleItem alloc]init];
    }
    if (!_paramsDic) {
        _paramsDic = [NSMutableDictionary dictionary];
    }
    [_dataArray removeAllObjects];
    NSArray *array = [LocalDataTool loadLocalArrayFromPath:currentPalletList];
    if (array.count) {
        for (NSDictionary *dic in array) {
            SaleItem *item = [[SaleItem alloc]init];
            [item setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:item];
        }
        [self.table reloadData];
    }else{
        [self.view addSubview:self.noDatasView];
    }
    [self setHeaderDefalutData];
    [self caculateTotal];
}

#pragma mark - -URLRequest
- (void)upLoadRecordsWithParams:(NSDictionary *)params completedBlock:(void(^)(NSObject *data))comletedBlock
{
    WeightHttpTool *request = [[WeightHttpTool alloc]initWithParam:[WeightHttpTool uploadSaleRecord:params]];
    [request setReturnBlock:^(NSURLSessionTask *task,NSURLResponse *response,id responseObject) {
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                if (comletedBlock) {
                    comletedBlock(data);
                }
            }
        }];
    }];
}

- (void)getPoStatusWithOrderID:(NSString *)orderId
{
    WeightHttpTool *request = [[WeightHttpTool alloc]initWithParam:[WeightHttpTool getPoStatusWithOrderID:orderId]];
    [request setReturnBlock:^(NSURLSessionTask *task,NSURLResponse *response, id responseObject) {
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                NSString *status = ((NSDictionary *)data)[@"payment_status"];
                if ([status isEqualToString:@"completed"]) {
                    // 记录 哪种方式支付的
                    [_paramsDic setValue:((NSDictionary *)data)[@"payment_type"] forKey:@"payment_type"];
                    
                    [self paySuccessEventCompletedBlock:nil];
                }else if ([status isEqualToString:@"closed"]){
                    if (self.paySelectView.superview){
                        showAlert(@"支付超时，请重新扫描二维码");
                        [self.paySelectView hide];
                    }
                    if (self.qrCodeView.superview){
                        showAlert(@"支付超时，请重新扫描二维码");
                        ReceiptsTDRespFrame *frame = [[ReceiptsTDRespFrame alloc] initWithProductId:0x0000 status:0x02];
                        [_btUtil writeFrameToPeripheral:frame];
                        [self.qrCodeView hide];
                    }
                }else if ([status isEqualToString:@"error"]){
                    if (self.paySelectView.superview){
                        showAlert(@"支付失败，用户已取消付款，请重新扫描二维码");
                        [self.paySelectView hide];
                    }
                    if (self.qrCodeView.superview){
                        showAlert(@"支付失败，用户已取消付款，请重新扫描二维码");
                        ReceiptsTDRespFrame *frame = [[ReceiptsTDRespFrame alloc] initWithProductId:0x0000 status:0x02];
                        [_btUtil writeFrameToPeripheral:frame];
                        [self.qrCodeView hide];
                    }
                }else{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (!self.paySelectView.superview && !self.qrCodeView.superview) return;
                        [self getPoStatusWithOrderID:orderId];
                    });
                }
            }
        }];
    }];
}
/** 成功支付 完成事件*/
- (void)paySuccessEventCompletedBlock:(void(^)())block
{
    [self.paySuccess showPrice:_paramsDic[@"paid_fee"] order:po_uuid animate:YES];
    if (po_uuid.length) {
        [_paramsDic setObject:po_uuid forKey:@"po_uuid"];
    }

    /** 数据库插入新数据 (异步)*/
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [WeightBussiness orderInsertToLocalSever:_paramsDic];
    });
    
    if (self.paySelectView.superview){
        [self.paySelectView hide];
        [self.dataArray removeAllObjects];
        [self.table reloadData];
        [self setHeaderDefalutData];
        [self caculateTotal];
        [LocalDataTool removeDocumAtPath:currentPalletList];
    }
    if (self.qrCodeView.superview){
        ReceiptsTDRespFrame *frame = [[ReceiptsTDRespFrame alloc] initWithProductId:0x0000 status:0x03];
        [_btUtil writeFrameToPeripheral:frame];
        [self.qrCodeView hide];
    }
    [self.view addSubview:self.noDatasView];
    if (block) {
        block();
    }
}
#pragma mark - -UITableViewDelegate&&DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIden = @"cell";
    GoodsSwapCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (!cell) {
        cell = [[GoodsSwapCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row < _dataArray.count) {
        cell.item = _dataArray[indexPath.row];
        cell.sepB.hidden = indexPath.row != _dataArray.count-1;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70*ALScreenScalHeight;
}

#pragma mark - delegate 删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataArray removeObjectAtIndex:indexPath.row];
        
        [self.table beginUpdates];
        [self.table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.table endUpdates];
        
        [self saveCurrentPallet];
        [self caculateTotal];
        if (!self.dataArray.count) {
            [self.view addSubview:self.noDatasView];
        }
    }
}

#pragma mark - 计算总价
- (void)caculateTotal
{
    NSInteger total = 0;
    for (SaleItem *item in self.dataArray) {
        total += item.total_price;
    }
    _totalPrice.attributedText = [ALCommonTool setAttrbute:@"总价：" andAttribute:[NSString stringWithFormat:@"%@元",[ALCommonTool decimalPointString:total/100.0f]] Color1:ALTextColor Color2:ALTextColor Font1:15 Font2:22];
    self.paySelectView.priceL.text = [NSString stringWithFormat:@"结算价：￥%@",[ALCommonTool decimalPointString:total/100.0f]];
    self.paySelectView.realPriceTextField.inputField.text = [ALCommonTool decimalPointString:(total/100.0f)];
}

#pragma mark - -BleDeviceDelegate
- (void)discoverBroadcastData:(BroadcastData *)data fromPeripheral:(CBPeripheral *)peripheral
{
    if (_btUtil.state == CsScaleStateOpened || _btUtil.state == CsScaleStateBroadcast) {
        if ([CsBtCommon getBoundMac] != nil && [[CsBtCommon getBoundMac] isEqualToString:data.mac]) {
            [_btUtil stopScanBluetoothDevice];
            // 绑定时同事要保存绑定设备在广播阶段传递过来的一些配置信息
            [CsBtCommon setBoundMac:data.mac];
            [CsBtCommon setUnitDecimalPoint:data.uDecimalPoint];
            [CsBtCommon setWeightDecimalPoint:data.wDecimalPoint];
            
            ScaleModel *model = [[ScaleModel alloc]init];
            [model setValuesForKeysWithDictionary:data.keyValues];
            [ScaleTool saveScale:model];
            
            [_btUtil connect:_btUtil.activePeripheral];
        }
    }
}

- (void)didUpdateCsScaleState:(CsScaleState)state
{
    if (state == CsScaleStateClosed || state == CsScaleStateConnected) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBar];
    }else if (state == CsScaleStateOpened){
        [_btUtil startScanBluetoothDevice];
    }
    _rightBar.state = state;
}

- (void)didHandShakeComplete:(BOOL)success
{
    [CsBtUtil getInstance].state = success?CsScaleStateShakeHandSuccess:CsScaleStateShakeHandSuccessFailure;
    if (success) {
        self.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBar];
    }else {
        if (self.navigationController.viewControllers.count>1) {
            [MBProgressHUD showError:@"PIN码不正确" compleBlock:^{
                SetPinningController *pin = [[SetPinningController alloc]init];
                [self.navigationController pushViewController:pin animated:YES];
            }];
        }
    }
}
#pragma mark - CSBtUtilDelegate 被动收款
/**被动收款*/
- (void)discoverTransactionDatas:(NSMutableArray *)datas
{
    if (self.qrCodeView.superview) {
        [MBProgressHUD showError:@"请先完成支付"];
        return;
    }
    [WeightBussiness dealPassivityWithArray:datas CompletedBlock:^(NSDictionary *params, CGFloat payfee) {
        if (payfee < 0) {
            [MBProgressHUD showError:@"无效金额，请重新输入"];
            return ;
        }
        [_paramsDic removeAllObjects];
        [_paramsDic addEntriesFromDictionary:params];
        [self.progressHud show:YES];
        self.progressHud.labelText = @"生成二维码中...";
        [self upLoadRecordsWithParams:params completedBlock:^(NSObject *data) {
            NSDictionary *dic = (NSDictionary *)data;
            po_uuid = dic[@"po_uuid"];
            NSString *alipayCode = dic[@"alipay"][@"code_url"];
            NSString *weixinPayCode = dic[@"weixin"][@"code_url"];
            [self.qrCodeView showCodeWithCodeURLs:@[alipayCode,weixinPayCode]];
            
            self.qrCodeView.priceL.text = [NSString stringWithFormat:@"结算价：￥%@",[ALCommonTool decimalPointString:payfee/100.0f]];
            [self getPoStatusWithOrderID:dic[@"po_uuid"]];
        }];
    }];
}
// 改由现金进行结算
- (void)cashPayment
{
    [self.qrCodeView hide];
    [_paramsDic setValue:@"cash" forKey:@"payment_type"];
    [self paySuccessEventCompletedBlock:nil];
}
// 取消交易
- (void)cancelPayment
{
    [self.qrCodeView hide];
    [self.view addSubview:self.noDatasView];
}
#pragma mark - CSBtUtilDelegate 主动收款
// 获得称重数据，并存在App的托盘上 主动收款
- (void)finishWeighing:(TransactionData *)data
{
    ALLog(@"%@",data);
    if (self.paySelectView.superview) {
        [MBProgressHUD showError:@"请先完成支付"];
        return;
    }
    [self.noDatasView hideAnimate:NO];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _weight = (data.weight)*1000.0f;
        NSDictionary *dic = [WeightBussiness blueToothDataTransfer:data];
        // 本地都用g 保存
        SaleItem *item = [[SaleItem alloc]init];
        [item setValuesForKeysWithDictionary:dic];
        item.unit = WeightUnit_Gram;
        item.ts = data.weightDate.timeStemp;
        _item = item;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_dataArray insertObject:item atIndex:0];
            [self saveCurrentPallet];
            [self headerWithModel:item];
            [self caculateTotal];
            [self.table insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        });
    });
}

- (void)discoverOfflineDatas:(NSMutableArray *)datas
{
    [WeightBussiness upLoadHistories:datas];
}

#pragma mark - headUIWithModel头部的UI数据模型处理
- (void)headerWithModel:(SaleItem *)model
{
    CGFloat scale = (CGFloat)[UnitTool defaultUnit]/model.unit;
    CGFloat quantity = model.quantity/scale;
    [_goodImage setImageWithIcon:model.icon];
    _priceL.text = [ALCommonTool decimalPointString:model.total_price/100.0f];
    _weightL.text = [NSString stringWithFormat:@"%@%@",[ALCommonTool decimalPointString:quantity],[UnitTool stringFromWeight:[UnitTool defaultUnit]]];
    if ([UnitTool defaultUnit]==WeightUnit_Gram) {
        _weightL.text = [NSString stringWithFormat:@"%@：%li%@",model.title,(long)quantity,[UnitTool stringFromWeight:[UnitTool defaultUnit]]];
    }
    
    CGFloat width = [self.priceL.text bundingWithSize:CGSizeMake(screenWidth, 50*ALScreenScalWidth) Font:50*ALScreenScalWidth].width;
    width = screenWidth-(width+self.goodsImageWidth.constant+32);
    self.goodImageLeading.constant = width/2.0f;
    [self.view setNeedsLayout];
}

- (void)setHeaderDefalutData
{
    _goodImage.image = [UIImage imageNamed:@"default"];
    _priceL.text = @"0";
    _weightL.text = [NSString stringWithFormat:@"0%@",[UnitTool stringFromWeight:[UnitTool defaultUnit]]];
    CGFloat width = [self.priceL.text bundingWithSize:CGSizeMake(screenWidth, 50*ALScreenScalWidth) Font:50*ALScreenScalWidth].width;
    width = screenWidth-(width+self.goodsImageWidth.constant+32);
    self.goodImageLeading.constant = width/2.0f;
    [self.view setNeedsLayout];
}

#pragma mark - -保存当前托盘
- (void)saveCurrentPallet
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (SaleItem *item in _dataArray) {
        [arr addObject:[item keyValues]];
    }
    [LocalDataTool saveAsLocalArrayWithPath:currentPalletList data:arr];
}
// 备份托盘
- (void)saveBackupPallet
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *array = [LocalDataTool loadLocalArrayFromPath:palletList];
        NSMutableArray *muArr = [NSMutableArray array];
        if (array.count) {
            [muArr addObjectsFromArray:array];
        }
        SaleItem *item = [_dataArray firstObject];
        [muArr insertObject:[item keyAndValues] atIndex:0];
        [LocalDataTool saveAsLocalArrayWithPath:palletList data:muArr];
        [self saveCurrentPallet];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_dataArray removeObjectAtIndex:0];
            [self.table beginUpdates];
            [self.table deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self.table endUpdates];
            
            [self setHeaderDefalutData];
            [self caculateTotal];
            if (!_dataArray.count) {
                [self.view addSubview:self.noDatasView];
            }
        });
    });
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
