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

@interface WeighingViewController ()<UITableViewDataSource,UITableViewDelegate,BleDeviceDelegate>
{
    NSString *code_url;
    CsBtUtil *_btUtil;
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

#pragma mark -layoutConstraint
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceTailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodImageLeading;
@property (nonatomic, strong) UIView *rightBar;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CGFloat weight;
@property (nonatomic, strong) SaleItem *item;

@end

@implementation WeighingViewController

- (UIView *)rightBar
{
    _rightBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 70, 20)];
    l.font = [UIFont systemFontOfSize:14];
    l.textColor = [UIColor whiteColor];
    [_rightBar addSubview:l];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(90, 12.5, 14, 15)];
    [_rightBar addSubview:imageV];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(connectToBLE)];
    _rightBar.userInteractionEnabled = YES;
    if ([CsBtUtil getInstance].state>=CsScaleStateConnected) {
        l.text = @"蓝牙已连接";
        imageV.image = [UIImage imageNamed:@"ble_connected.png"];
        [_rightBar removeGestureRecognizer:tap];
    }else{
        l.text = @"蓝牙未连接";
        imageV.image = [UIImage imageNamed:@"ble_noconnect.png"];
        [_rightBar addGestureRecognizer:tap];
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

- (WeightNoDatasView *)noDatasView
{
    if (!_noDatasView) {
        _noDatasView = [WeightNoDatasView loadXibView];
        _noDatasView.frame = self.view.bounds;
        [self.view addSubview:_noDatasView];
    }
    return _noDatasView;
}

- (IBAction)btnClick:(id)sender
{
    if ([sender tag]) {
        [self.paySelectView showAnimate:YES];
    }else{
        NSArray *array = [LocalDataTool loadLocalArrayFromPath:palletList];
        NSMutableArray *muArr = [NSMutableArray array];
        if (array) {
            [muArr addObjectsFromArray:array];
        }
        NSMutableArray *temp = [NSMutableArray array];
        for (SaleItem *item in _dataArray) {
            [temp addObject:[item keyValues]];
        }
        [muArr addObject:temp];
        if (!muArr.count) {
            [MBProgressHUD showMessage:@"没有东西可以放入托盘哦~"];
            return;
        }
        [LocalDataTool saveAsLocalArrayWithPath:palletList data:muArr];
        [_dataArray removeAllObjects];
        [self.table reloadData];
        [MBProgressHUD showMessage:@"放入托盘成功"];
        [self.view addSubview:self.noDatasView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    _btUtil.delegate = self;
    if (![ScaleTool scale].mac.length) {
        [_btUtil stopScanBluetoothDevice];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBar];
}

- (void)viewDidLoad {
    WS(weakSelf);
    [super viewDidLoad];
    _btUtil = [CsBtUtil getInstance];
    [self initFromXib];
    [self buildNavBarItems];
    [self datas];
    /**
     * 添加观察 单位设置变动
     */
    [self noticeGlobalUnitChanged:^{
        [weakSelf headerWithModel:weakSelf.item];
        [weakSelf.table reloadData];
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SWTableViewCellScrollNotice:) name:SWTableViewCellBeginScrollNotice object:nil];
    
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
    
    /**
     * 图片和价格居中显示
     */
    CGFloat width = [self.priceL.text bundingWithSize:CGSizeMake(screenWidth, 50*ALScreenScalWidth) Font:50*ALScreenScalWidth].width;
    width = screenWidth-(width+self.goodsImageWidth.constant+80);
    self.goodImageLeading.constant = width/2.0f;
    self.priceTailing.constant = width/2.0f;
    
    _goodImage.layer.cornerRadius = 32.5f*ALScreenScalWidth;
    _goodImage.layer.masksToBounds = YES;
    _unitL.textColor = ALTextColor;
    _priceL.textColor = ALTextColor;
    _priceL.font = [UIFont systemFontOfSize:50*ALScreenScalWidth];
    
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
//        GoodsListController *pctl = [[GoodsListController alloc]init];
        [weakSelf.navigationController pushViewController:pctl animated:YES];
    }];
}

- (void)connectToBLE
{
    OpenBleController *open = [[OpenBleController alloc]init];
    [self.navigationController pushViewController:open animated:YES];
}

- (void)datas
{
    _dataArray = [NSMutableArray array];
    _item = [[SaleItem alloc]init];
    /**
     * 托盘列表数据
     */
//    NSArray *array = [LocalDataTool loadLocalArrayFromPath:palletList];
//    if (array) {
//        for (NSDictionary *dic in [array lastObject]) {
//            SaleItem *item = [[SaleItem alloc]init];
//            [item setValuesForKeysWithDictionary:dic];
//            [_dataArray addObject:item];
//        }
//    }
//    [self caculateTotal];
}

#pragma mark -URLRequest
- (void)uploadRecordsWithType:(PayWayType)type
{
    [self.progressHud show:YES];
    NSString *payWay = nil;
    if (type == PayWayTypeCrash) {
        payWay = @"cash";
    }else if (type == PayWayTypeWechatPay){
        payWay = @"weixin";
    }else{
        payWay = @"alipay";
    }
    NSString *price = [[self.paySelectView.priceL.text componentsSeparatedByString:@"￥"] lastObject];
    NSMutableArray *datas = [NSMutableArray array];
    for (SaleItem *item in _dataArray) {
        item.discount = [self.paySelectView.realPriceTextField.inputField.text floatValue]/[price floatValue];
        item.ts = [NSDate date].timeStempString;
        NSDictionary *dic = [item keyValues];
        [dic setValue:@"g" forKey:@"unit"];
        NSNumber *number = dic[@"quantity"];
        [dic setValue:@([number integerValue]*item.unit) forKey:@"quantity"];
        [datas addObject:dic];
    }
    
    NSDictionary *params = @{@"randid":[NSString radom11BitString],@"ts":@([NSDate date].timeStempString),@"title":@"支付测试",@"total_fee":@([price floatValue]*100),@"paid_fee":@([self.paySelectView.realPriceTextField.inputField.text floatValue]*100),@"payment_type":payWay,@"items":datas};
    /**
     * 数据库插入新数据 (异步)
     */
    SaleTable *salT = [[SaleTable alloc]init];
    [salT setValuesForKeysWithDictionary:params];
    salT.items = _dataArray;
    [[SaleTable getUsingLKDBHelper] insertToDB:salT callback:nil];
    /**
     * 网络请求
     */
    WeightHttpTool *request = [[WeightHttpTool alloc]initWithParam:[WeightHttpTool uploadSaleRecord:params]];
    [request setReturnBlock:^(NSURLSessionTask *task,NSURLResponse *response,id responseObject) {
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                if (type!=PayWayTypeCrash) {
                    code_url = ((NSDictionary *)data)[@"code_url"];
                    [self.paySelectView showSuccessQrImage:code_url];
                    [self getPoStatusWithOrderID:((NSDictionary *)data)[@"po_uuid"]];
                }else{
                    [MBProgressHUD showSuccess:@"支付成功"];
                    [self.dataArray removeAllObjects];
                    [self.table reloadData];
                    [self.paySelectView hide];
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
                    [MBProgressHUD showSuccess:@"支付成功"];
                    [self.paySelectView hide];
                    [self.dataArray removeAllObjects];
                    [self.table reloadData];
                }else{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (!self.paySelectView.superview) return;
                        [self getPoStatusWithOrderID:orderId];
                    });
                }
            }
        }];
    }];
}
#pragma mark - UITableViewDelegate&&DataSource
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

#pragma mark - Notice
- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath
{
    YSAlertView *alert = [[YSAlertView alloc]initWithTitle:@"" message:@"确定删除么？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定" click:^(NSInteger index) {
        if (index) {
            [_dataArray removeObjectAtIndex:indexPath.row];
            [self caculateTotal];
            [self.table reloadData];
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

/**
 * 计算总价
 */
- (void)caculateTotal
{
    CGFloat total = 0.0f;
    for (SaleItem *item in self.dataArray) {
        total += (CGFloat)(item.unit_price*item.quantity)/100.0f;
    }
    _totalPrice.attributedText = [ALCommonTool setAttrbute:@"总价：" andAttribute:[NSString stringWithFormat:@"%.2f元",total] Color1:ALTextColor Color2:ALTextColor Font1:15 Font2:22];
    self.paySelectView.priceL.text = [NSString stringWithFormat:@"结算价：￥%.2f",total];
}

#pragma mark BleDeviceDelegate
- (void)discoverBroadcastData:(BroadcastData *)data fromPeripheral:(CBPeripheral *)peripheral
{
    if (_btUtil.state == CsScaleStateOpened || _btUtil.state == CsScaleStateBroadcast) {
        if ([[ScaleTool scale].mac isEqualToString:data.mac]) {
            [_btUtil connectToPeripheral:peripheral];
        }
    }
}

/** 发现透传数据*/
- (void)discoverStraightData:(StraightData *)data
{
    ALLog(@"%@",data);
    [self.noDatasView hideAnimate:NO];
    WS(weakSelf);
    _weight = (data.weight)*1000.0f;
    [[GoodsInfoModel getUsingLKDBHelper]search:[GoodsInfoModel class] where:@{@"number":@(data.productId)} orderBy:nil offset:0 count:1000 callback:^(NSMutableArray *array) {
        if (array.count) {
            GoodsInfoModel *model = array[0];
            SaleItem *item = [[SaleItem alloc]init];
            [item setValuesForKeysWithDictionary:[model keyValues]];
            item.quantity = self.weight/(CGFloat)item.unit;
            _item = item;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self headerWithModel:item];
                [self.dataArray addObject:item];
                [self caculateTotal];
                [self.table reloadData];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                GoodsListController *goodList = [[GoodsListController alloc]init];
                goodList.callBack = ^(GoodsInfoModel *model){
                    SaleItem *item = [[SaleItem alloc]init];
                    [item setValuesForKeysWithDictionary:[model keyValues]];
                    [item setValuesForKeysWithDictionary:[model keyValues]];
                    item.quantity = weakSelf.weight/(CGFloat)item.unit;
                    [weakSelf.dataArray addObject:item];
                    [weakSelf.table reloadData];
                    [weakSelf headerWithModel:item];
                    [weakSelf caculateTotal];
                };
                goodList.number = @(data.productId);
                [self.navigationController pushViewController:goodList animated:YES];
            });
        }
    }];
}

#pragma mark -
/** 连接设备成功的回调*/
- (void)connectedPeripheral:(CBPeripheral *)peripheral
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBar];
    
}

/**  断开设备的回调*/
-(void)didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [_btUtil startScanBluetoothDevice];
}

/** 完成同步单价*/
- (void)syncProductComplete:(int)productId success:(BOOL)success
{
    
}

- (void)didUpdateCsScaleState:(CsScaleState)state
{
    switch (state) {
        case CsScaleStateOpened:
//            [_btUtil->_manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
            break;
        case CsScaleStateClosed:
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBar];
}
#pragma mark - headUIWithModel头部的UI数据模型处理
- (void)headerWithModel:(SaleItem *)model
{
    CGFloat scale = (CGFloat)[UnitTool defaultUnit]/model.unit;
    CGFloat quantity = model.quantity/scale;
    _goodImage.image = [UIImage imageFromSeverName:model.icon];
    _priceL.text = [NSString stringWithFormat:@"%.2f元",(model.unit_price*model.quantity)/100.0f];
    if ([[_priceL.text componentsSeparatedByString:@"."] lastObject].length>3) {
        _priceL.text = [NSString stringWithFormat:@"%.2f元",(model.unit_price*model.quantity)/100.0f];
    }
    _weightL.text = [NSString stringWithFormat:@"%.2f%@",quantity,[UnitTool stringFromWeight:[UnitTool defaultUnit]]];
    if ([UnitTool defaultUnit]==WeightUnit_Gram) {
        _weightL.text = [NSString stringWithFormat:@"%@：%li%@",model.title,(long)quantity,[UnitTool stringFromWeight:[UnitTool defaultUnit]]];
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
