//
//  PalletViewController.m
//  BusinessScale
//
//  Created by Alvin on 15/12/16.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "PalletViewController.h"
#import "palletCell.h"
#import "PalletSecctionView.h"
#import "PayWaySelectView.h"
#import "WeightHttpTool.h"
#import "WeightBussiness.h"
@interface PalletViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *code_url;
    NSString *po_uuid;
    NSMutableDictionary *_paramsDic;
}
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (weak, nonatomic) IBOutlet UILabel *allSelectedL;
@property (weak, nonatomic) IBOutlet UIButton *payMoneyBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceL;
@property (weak, nonatomic) IBOutlet UILabel *totalL;
@property (weak, nonatomic) IBOutlet UIView *seletedBtn;
@property (weak, nonatomic) IBOutlet UIImageView *allSelecteImageV;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) PayWaySelectView *paySelectView;
@property (nonatomic, strong) NoDataView *noDataView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *payItemsArray;
@property (nonatomic, assign) BOOL allSelected;

@end

@implementation PalletViewController

- (NoDataView *)noDataView
{
    if (!_noDataView) {
        _noDataView = [NoDataView loadXibView];
        _noDataView.frame = self.view.bounds;
        _noDataView.noDataL.text = @"托盘上暂无数据";
    }
    return _noDataView;
}

- (NSMutableArray *)payItemsArray
{
    if (!_payItemsArray) {
        _payItemsArray = [NSMutableArray array];
    }
    [_payItemsArray removeAllObjects];
    for (palletCellModel *model in self.dataArray) {
        if (model.isSelected) {
            [_payItemsArray addObject:model];
        }
    }
    return _payItemsArray;
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
    NSDictionary *params = [self buildUpLoadParams];
    if (!params) {
        return;
    }
    [_paramsDic removeAllObjects];
    [_paramsDic addEntriesFromDictionary:params];
    [_paramsDic setObject:payWay forKey:@"payment_type"];
    
    if ([Reachability shareReachAbilty].currentReachabilityStatus == NotReachable) {
        if (type == PayWayTypeCrash) {
            [self paySuccessEvent];
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
            [self getPoStatusWithOrderID:((NSDictionary *)data)[@"po_uuid"]];
        }else{
            [self paySuccessEvent];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFromXib];
    [self buildNavBarItems];
    self.title = @"托盘";
    [self datas];
}

- (void)initFromXib
{
    _bottomBar.backgroundColor = backGroudColor;
    _allSelectedL.textColor = ALTextColor;
    _totalL.textColor = ALLightTextColor;
    _totalPriceL.textColor = ALRedColor;
    _payMoneyBtn.backgroundColor = ALRedColor;
    [_payMoneyBtn addTarget:self action:@selector(payMoney) forControlEvents:UIControlEventTouchUpInside];
    [_seletedBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seletedAll)]];
    
    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 0.5)];
    l.backgroundColor = separateLabelColor;
    [_bottomBar addSubview:l];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"palletCell" bundle:nil] forCellReuseIdentifier:@"cellInde"];
}

- (void)datas
{
    _dataArray = [NSMutableArray array];
    _paramsDic = [NSMutableDictionary dictionary];
    self.allSelected = YES;
    [self initDatas];
}

- (void)initDatas
{
    [_dataArray removeAllObjects];
    NSArray *array = [LocalDataTool loadLocalArrayFromPath:palletList];
    for (NSDictionary *dic in array) {
        palletCellModel *sal = [[palletCellModel alloc]init];
        [sal setValuesForKeysWithDictionary:dic];
        sal.isSelected = YES;
        [_dataArray addObject:sal];
    }
    if (!_dataArray.count) {
        [self.view addSubview:self.noDataView];
    }
    [self.tableView reloadData];
    [self caculateTotals];
}

- (void)buildNavBarItems
{
    WS(weakSelf);
    [self addNavRightBarBtn:@"清空" selectorBlock:^{
        if (weakSelf.dataArray.count) {
            [weakSelf.dataArray removeAllObjects];
            [weakSelf saveBackUpPallet];
            [weakSelf.tableView reloadData];
            [MBProgressHUD showSuccess:@"数据已全部清除"];
            if (!weakSelf.noDataView.superview) {
                [weakSelf.view addSubview:weakSelf.noDataView];
            }
        }else{
            [MBProgressHUD showMessage:@"托盘上空空如也~"];
        }
    }];
}

- (void)seletedAll
{
    self.allSelected = !self.allSelected;
    if (self.allSelected) {
        _allSelecteImageV.image = [UIImage imageNamed:@"icon_sel"];
    }else{
        _allSelecteImageV.image = [UIImage imageNamed:@"icon_nor"];
    }
    for (palletCellModel *model in self.dataArray) {
        model.isSelected = self.allSelected;
    }
    [self caculateTotals];
    [self.tableView reloadData];
}

- (void)payMoney
{
    if (!self.payItemsArray.count) {
        [MBProgressHUD showMessage:@"请选择至少一个结算商品"];
        return;
    }
    [self.paySelectView showAnimate:YES];
}

#pragma mark -构建上传参数
- (NSDictionary *)buildUpLoadParams
{
    NSString *price = [[self.paySelectView.priceL.text componentsSeparatedByString:@"￥"] lastObject];
    NSInteger paid_fee = (NSInteger)([self.paySelectView.realPriceTextField.inputField.text floatValue]*100.0f+0.5);
    NSInteger totals_fee = (NSInteger)([price floatValue]*100.0f+0.5);
    if (paid_fee > totals_fee) {
        [MBProgressHUD showMessage:@"折扣价不能大于总价，请修改价格"];
        return nil;
    }
    [self.progressHud show:YES];
    
    NSDictionary *params = [WeightBussiness upLoadDatasTransfer:totals_fee payFee:paid_fee datas:self.payItemsArray];
    return params;
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
                [_paramsDic setValue:@(NO) forKey:@"isUpLoad"];
                if ([status isEqualToString:@"completed"]) {
                    [self paySuccessEvent];
                    [_paramsDic setValue:@(YES) forKey:@"isUpLoad"];
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

- (void)paySuccessEvent
{
    [self.paySuccess showPrice:_paramsDic[@"paid_fee"] order:po_uuid animate:YES];
    if (po_uuid.length) {
        [_paramsDic setObject:po_uuid forKey:@"po_uuid"];
    }
    
    /** 数据库插入新数据 (异步)*/
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [WeightBussiness orderInsertToLocalSever:_paramsDic];
    });

    [self.dataArray removeObjectsInArray:self.payItemsArray];
    [self caculateTotals];
    [self.tableView reloadData];
    [self.paySelectView hide];
    [self saveBackUpPallet];
}

#pragma mark - UITableViewDelegate&&UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakSelf);
    static NSString *indenty = @"cellInde";
    palletCell *cell = [tableView dequeueReusableCellWithIdentifier:indenty];
    if (!cell) {
        cell = [[palletCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indenty];
    }
    NSArray *arr = self.dataArray;
    if (indexPath.row < arr.count) {
        cell.sepT.hidden = indexPath.row;
        cell.model = arr[indexPath.row];
        cell.callBack = ^(palletCell *cell){
            NSIndexPath *path = [tableView indexPathForCell:cell];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
            [weakSelf caculateTotals];
        };
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f*ALScreenScalWidth;
}

#pragma mark - delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        [self saveBackUpPallet];
        [self caculateTotals];
    }
}

#pragma mark - -计算物品总价
- (void)caculateTotals
{
    CGFloat total = 0.0f;
    for (int i = 0; i<_dataArray.count; i++) {
        palletCellModel *model = _dataArray[i];
        if (model.isSelected) {
            total += (model.total_price)/100.0f;
        }
    }
    _totalPriceL.text = [NSString stringWithFormat:@"￥%@",[ALCommonTool decimalPointString:total]];
    self.paySelectView.priceL.text = [NSString stringWithFormat:@"结算价：￥%@",[ALCommonTool decimalPointString:total]];
    self.paySelectView.realPriceTextField.inputField.text = [ALCommonTool decimalPointString:total];
    
    if (!self.dataArray.count) {
        [self.view addSubview:self.noDataView];
    }
}

#pragma mark - -保存备份托盘
- (void)saveBackUpPallet
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (SaleItem *item in self.dataArray) {
            [arr addObject:[item keyValues]];
        }
        if (arr.count) {
            [LocalDataTool saveAsLocalArrayWithPath:palletList data:arr];
        }else{
            [LocalDataTool removeDocumAtPath:palletList];
        }
    });
}

@end
