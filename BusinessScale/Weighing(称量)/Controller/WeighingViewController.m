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
#import "QrCodeViewController.h"
#import <Commercial-Bluetooth/CsBtUtil.h>
#import "OpenBleController.h"
#import "GoodsListHttpTool.h"
#import "BoundDeviceController.h"
#import "QuardCodeView.h"
#import "SettingBussiness.h"

#define currentPalletList [NSString stringWithFormat:@"currentPalletList%@",[AccountTool account].ID]

@interface WeighingViewController ()<UITableViewDataSource,UITableViewDelegate,BleDeviceDelegate>
{
    NSString *code_url;
    CsBtUtil *_btUtil;
    NSMutableDictionary *_paramsDic;
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
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceTailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodImageLeading;
@property (nonatomic, strong) UIView *rightBar;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CGFloat weight;
@property (nonatomic, strong) SaleItem *item;

@end

@implementation WeighingViewController
#pragma mark - -getter
- (UIView *)rightBar
{
    if (!_rightBar) {
         _rightBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 70, 20)];
        l.tag = 100;
        l.font = [UIFont systemFontOfSize:14];
        l.textColor = [UIColor whiteColor];
        [_rightBar addSubview:l];
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(90, 12.5, 14, 15)];
        imageV.tag = 1000;
        [_rightBar addSubview:imageV];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(connectToBLE)];
        _rightBar.userInteractionEnabled = YES;
        [_rightBar addGestureRecognizer:tap];
    }
    
    UILabel *l = [_rightBar viewWithTag:100];
    UIImageView *imageV = [_rightBar viewWithTag:1000];
    if ([CsBtUtil getInstance].state>=CsScaleStateConnected) {
        l.text = @"蓝牙已连接";
        imageV.image = [UIImage imageNamed:@"ble_connected.png"];
    }else{
        l.text = @"蓝牙未连接";
        imageV.image = [UIImage imageNamed:@"ble_noconnect.png"];
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
            }else if (weakSelf.dataArray.count){
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
        [self.view addSubview:_noDatasView];
    }
    return _noDatasView;
}
#pragma mark - -viewDidLoad
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    _btUtil.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _btUtil = [CsBtUtil getInstance];
    _btUtil.delegate = self;
    [self initFromXib];
    [self buildNavBarItems];
    [self registNotifications];
    [self datas];
    [self.noDatasView showAnimate:YES];
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
//    self.priceTailing.constant = width/2.0f;
    
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
    self.navigationItem.title = @"OKOK计量";
    
    [self addNavLeftBarBtn:@"进入托盘" selectorBlock:^{
        PalletViewController *pctl = [[PalletViewController alloc]init];
        [weakSelf.navigationController pushViewController:pctl animated:YES];
    }];
}
#pragma mark - -观察
- (void)registNotifications
{
    WS(weakSelf);
    /**添加观察 单位设置变动*/
    [self noticeGlobalUnitChanged:^{
        [weakSelf headerWithModel:weakSelf.item];
        [weakSelf.table reloadData];
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SWTableViewCellScrollNotice:) name:SWTableViewCellBeginScrollNotice object:nil];
}

#pragma mark - -actions
- (IBAction)btnClick:(id)sender
{
    if ([sender tag]) {
        [self.paySelectView showAnimate:YES];
    }else{
        NSArray *array = [LocalDataTool loadLocalArrayFromPath:palletList];
        NSMutableArray *muArr = [NSMutableArray array];
        if (array.count) {
            [muArr addObjectsFromArray:array];
        }
        SaleItem *item = [_dataArray lastObject];
        [muArr addObject:[item keyValues]];
        [LocalDataTool saveAsLocalArrayWithPath:palletList data:muArr];
        [_dataArray removeObject:item];
        [self saveCurrentPallet];
        [self.table reloadData];
        [self setHeaderDefalutData];
        [self caculateTotal];
        [MBProgressHUD showMessage:@"放入托盘成功"];
    }
}

- (void)uploadRecordsWithType:(PayWayType)type
{
    [self.progressHud show:YES];
    NSString *payWay = nil;
    if (type == PayWayTypeCrash) {
        payWay = @"cash";
    }else if (type == PayWayTypeWechatPay){
        payWay = @"weixin";
    }else if(type == PayWayTypeAlipay){
        payWay = @"alipay";
    }else if (type == PayWayTypeOnline){
        payWay = @"online";
    }
    NSString *price = [[self.paySelectView.priceL.text componentsSeparatedByString:@"￥"] lastObject];
    NSMutableArray *datas = [NSMutableArray array];
    NSMutableString *string = [NSMutableString string];
    NSInteger i = 0;
    for (SaleItem *item in _dataArray) {
//        item.ts = [NSDate date].timeStempString;
        NSDictionary *dic = [item keyValues];
        [dic setValue:@"g" forKey:@"unit"];
        NSNumber *number = dic[@"quantity"];
        [dic setValue:@([number floatValue]) forKey:@"quantity"];
        [datas addObject:dic];
        if (i<2) {
            [string appendString:item.title];
            [string appendString:@" "];
        }
        if (i==_dataArray.count-1) {
            [string appendString:[NSString stringWithFormat:@"等%i样",(int)(i+1)]];
        }
        i++;
    }
    NSDictionary *params = @{@"randid":[NSString radom11BitString],@"ts":@([NSDate date].timeStempString),@"title":string,@"total_fee":@([price floatValue]*100),@"paid_fee":@([self.paySelectView.realPriceTextField.inputField.text floatValue]*100),@"payment_type":payWay,@"items":datas};
    [_paramsDic removeAllObjects];
    [_paramsDic addEntriesFromDictionary:params];
    [self upLoadRecordsWithParams:_paramsDic completedBlock:^(NSObject *data){
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
            [self getPoStatusWithOrderID:((NSDictionary *)data)[@"po_uuid"]];
        }else{
            [self paySuccessEventCompletedBlock:^{
                [LocalDataTool removeDocumAtPath:currentPalletList];
            }];
        }
    }];
}

- (void)connectToBLE
{
    if ([CsBtUtil getInstance].state>=CsScaleStateConnected) return;
    if (_btUtil.state != CsScaleStateClosed) {
        BoundDeviceController *bound = [[BoundDeviceController alloc]init];
        [self.navigationController pushViewController:bound animated:YES];
        return;
    }
    OpenBleController *open = [[OpenBleController alloc]init];
    [self.navigationController pushViewController:open animated:YES];
}

#pragma mark - -datas
- (void)datas
{
    _dataArray = [NSMutableArray array];
    _item = [[SaleItem alloc]init];
    _paramsDic = [NSMutableDictionary dictionary];
    NSArray *array = [LocalDataTool loadLocalArrayFromPath:currentPalletList];
    if (array.count) {
        for (NSDictionary *dic in array) {
            SaleItem *item = [[SaleItem alloc]init];
            [item setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:item];
        }
        [self.noDatasView removeFromSuperview];
        [self.table reloadData];
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
                    [self paySuccessEventCompletedBlock:^{
                        
                    }];
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
    [MBProgressHUD showSuccess:@"支付成功"];
    /** 数据库插入新数据 (异步)*/
    SaleTable *salT = [[SaleTable alloc]init];
    [salT setValuesForKeysWithDictionary:_paramsDic];
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *items = _paramsDic[@"items"];
    NSInteger i = 0;
    CGFloat paids = 0.0f;
    for (NSDictionary *dic in items) {
        SaleItem *item = [[SaleItem alloc]init];
        [item setValuesForKeysWithDictionary:dic];
        [arr addObject:item];
        item.unit = WeightUnit_Gram;
        item.discount = [_paramsDic[@"paid_fee"] floatValue]/[_paramsDic[@"total_fee"] floatValue];
        item.paid_price = (item.total_price*item.discount);
        if (!item.ts) {
            item.ts = [NSDate date].timeStempString;
        }
        if (i==items.count-1) {
            item.paid_price = (NSInteger)([_paramsDic[@"paid_fee"] floatValue] - paids);
        }
        paids += item.paid_price;
        i++;
    }
    salT.items = arr;
    [[SaleTable getUsingLKDBHelper] insertToDB:salT callback:nil];
    
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
    WS(weakSelf);
    static NSString *cellIden = @"cell";
    GoodsSwapCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (!cell) {
        NSMutableArray *rightUtilityButtons = [NSMutableArray array];
        [rightUtilityButtons addUtilityButtonWithColor:[UIColor redColor] title:@"删除"];
        tableView.rowHeight = 70*ALScreenScalHeight;
        cell = [[GoodsSwapCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                    reuseIdentifier:cellIden
                                containingTableView:tableView
                                 leftUtilityButtons:nil
                                rightUtilityButtons:rightUtilityButtons];
    }
    if (indexPath.row < _dataArray.count) {
        cell.item = _dataArray[indexPath.row];
        cell.sepB.hidden = indexPath.row != _dataArray.count-1;
        cell.rightBtnBlock = ^(NSInteger index){
            [weakSelf deleteRowAtIndexPath:indexPath];
        };
    }
    return cell;
}

#pragma mark - -删除
- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSAlertView *alert = [[YSAlertView alloc]initWithTitle:@"" message:@"确定删除么？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定" click:^(NSInteger index) {
        if (index) {
            [_dataArray removeObjectAtIndex:indexPath.row];
            [self saveCurrentPallet];
            [self caculateTotal];
//            [self.table reloadData];
            [self.table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
    [alert show];
}

- (void)SWTableViewCellScrollNotice:(NSNotification *)notice
{
    static SWTableViewCell *formerCell = nil;
    SWTableViewCell *currentCell = (SWTableViewCell *)notice.object;
    if (formerCell != currentCell) {
        [formerCell hideUtilityButtonsAnimated:YES];
    }
    formerCell = currentCell;
}

#pragma mark - 计算总价
- (void)caculateTotal
{
    CGFloat total = 0.0f;
    for (SaleItem *item in self.dataArray) {
        total += (CGFloat)((item.total_price)/100.0f);
    }
    _totalPrice.attributedText = [ALCommonTool setAttrbute:@"总价：" andAttribute:[NSString stringWithFormat:@"%@元",[ALCommonTool decimalPointString:total]] Color1:ALTextColor Color2:ALTextColor Font1:15 Font2:22];
    self.paySelectView.priceL.text = [NSString stringWithFormat:@"结算价：￥%@",[ALCommonTool decimalPointString:total]];
}

#pragma mark - -BleDeviceDelegate
- (void)discoverBroadcastData:(BroadcastData *)data fromPeripheral:(CBPeripheral *)peripheral
{
    if (_btUtil.state == CsScaleStateOpened || _btUtil.state == CsScaleStateBroadcast) {
        if (_btUtil.state < CsScaleStateConnected) {
            if ([CsBtCommon getBoundMac] != nil && [[CsBtCommon getBoundMac] isEqualToString:data.mac]) {
                [_btUtil stopScanBluetoothDevice];
                // 绑定时同事要保存绑定设备在广播阶段传递过来的一些配置信息
                [CsBtCommon setBoundMac:data.mac];
                [CsBtCommon setUnitDecimalPoint:data.uDecimalPoint];
                [CsBtCommon setWeightDecimalPoint:data.wDecimalPoint];
                
                [_btUtil connect:_btUtil.activePeripheral];
            }
        }
    }
}

- (void)didUpdateCsScaleState:(CsScaleState)state
{
    if (state == CsScaleStateClosed) {
        self.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBar];
    }else if (state == CsScaleStateOpened){
        [_btUtil startScanBluetoothDevice];
    }
}

- (void)didHandShakeComplete:(BOOL)success
{
    self.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBar];
}
#pragma mark - CSBtUtilDelegate 被动收款
/**
 *  发现交易记录数据
 *  用于被动收款的场景、即秤端算好价格App来付款
 *  @param data 交易记录数据
 */
- (void)discoverTransactionDatas:(NSMutableArray *)datas {
    
    [WeightBussiness dealPassivityWithArray:datas CompletedBlock:^(NSDictionary *params, CGFloat payfee) {
        [_paramsDic removeAllObjects];
        [_paramsDic addEntriesFromDictionary:params];
        [self.progressHud show:YES];
        self.progressHud.labelText = @"生成二维码中...";
        [self upLoadRecordsWithParams:params completedBlock:^(NSObject *data) {
            NSDictionary *dic = (NSDictionary *)data;
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
    [self paySuccessEventCompletedBlock:nil];
}
// 取消交易
- (void)cancelPayment
{
    [self.qrCodeView hide];
}
#pragma mark - CSBtUtilDelegate 主动收款
// 获得称重数据，并存在App的托盘上 主动收款
- (void)finishWeighing:(TransactionData *)data
{
    ALLog(@"%@",data);
    [self.noDatasView hideAnimate:NO];
    _weight = (data.weight)*1000.0f;
    NSMutableDictionary *sqlDic = [NSMutableDictionary dictionary];
    if ([AccountTool account].ID) [sqlDic setObject:[AccountTool account].ID forKey:@"uid"];
    if ([ScaleTool scale].mac) [sqlDic setObject:[ScaleTool scale].mac forKey:@"mac"];
    [sqlDic setObject:@(data.productId) forKey:@"number"];
    
    NSArray *array = [[GoodsInfoModel getUsingLKDBHelper]search:[GoodsInfoModel class] where:sqlDic orderBy:nil offset:0 count:0];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (array.count) {
            GoodsInfoModel *model = array[0];
            NSDictionary *dic = @{@"title": model.title, @"unit_price": @((data.unitPrice/1000.0f*100.0f)), @"unit": @"g", @"quantity":@(data.weight*1000),@"icon":model.icon,@"total_price":@((NSInteger)(data.totalPrice*100.0f))};
            // 本地都用g 保存
            SaleItem *item = [[SaleItem alloc]init];
            [item setValuesForKeysWithDictionary:dic];
            item.unit = WeightUnit_Gram;
            item.ts = data.weightDate.timeStempString;
            _item = item;
//            [_dataArray addObject:item];
            [_dataArray insertObject:item atIndex:0];
            [self saveCurrentPallet];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self headerWithModel:item];
                [self caculateTotal];
                [self.table insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            });
        }
    });
}

- (void)discoverOfflineDatas:(NSMutableArray *)datas
{
    [SettingBussiness upLoadHistories:datas];
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
