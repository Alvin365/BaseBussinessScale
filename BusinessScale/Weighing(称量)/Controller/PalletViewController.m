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
@interface PalletViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *code_url;
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


@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSArray *payItemsArray;
@property (nonatomic, assign) BOOL allSelected;

@end

@implementation PalletViewController

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
                [weakSelf upLoadRecordWithType:type];
            }
        };
    }
    return _paySelectView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFromXib];
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
        [_dataArray addObject:dic];
    }
    [self caculateTotals];
}

- (void)seletedAll
{
    self.allSelected = !self.allSelected;
    if (self.allSelected) {
        _allSelecteImageV.image = [UIImage imageNamed:@"icon_sel"];
    }else{
        _allSelecteImageV.image = [UIImage imageNamed:@"icon_nor"];
    }
    for (NSArray *arr in self.dataArray) {
        for (palletCellModel *model in arr) {
            model.isSelected = self.allSelected;
        }
    }
    [self caculateTotals];
    [self.tableView reloadData];
}

- (void)payMoney
{
    [self.paySelectView showAnimate:YES];
}

#pragma mark - netRequest
- (void)upLoadRecordWithType:(PayWayType )type
{
    [self.progressHud show:YES];
    NSMutableArray *muArr = [NSMutableArray array];
    SaleTable *salT = [[SaleTable alloc]init];
    salT.title = @"支付测试";
    salT.randid = [NSString radom11BitString];
    salT.total_fee = [[[_totalPriceL.text componentsSeparatedByString:@"￥"] lastObject] floatValue]*100;
    salT.paid_fee = [self.paySelectView.realPriceTextField.inputField.text floatValue]*100;
    salT.payment_type = type==PayWayTypeCrash?(type==PayWayTypeAlipay?@"alipay":@"weixin"):@"weixin";
    for (palletCellModel *model in _dataArray) {
        model.unit = WeightUnit_Gram;
        if (model.isSelected) {
            [muArr addObject:model];
        }
    }
    salT.items = muArr;
    self.payItemsArray = [muArr copy];
    /**
     * 插入数据库
     */
    [[SaleTable getUsingLKDBHelper]insertToDB:salT callback:nil];
    
    WeightHttpTool *request = [[WeightHttpTool alloc]initWithParam:[WeightHttpTool uploadSaleRecord:salT.keyValues]];
    [request setReturnBlock:^(NSURLSessionTask *task,NSURLResponse *response,id responseObject) {
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                if (type!=PayWayTypeCrash) {
                    code_url = ((NSDictionary *)data)[@"code_url"];
                    [self.paySelectView showSuccessQrImage:code_url];
                    [self getPoStatusWithOrderID:((NSDictionary *)data)[@"po_uuid"]];
                }else{
                    [self.progressHud show:YES];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.progressHud hide:YES];
                        [self paySuccessEvent];
                    });
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
                    [self paySuccessEvent];
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
    [MBProgressHUD showSuccess:@"支付成功"];
    [self.dataArray removeObjectsInArray:self.payItemsArray];
    [LocalDataTool saveAsLocalArrayWithPath:palletList data:self.dataArray];
    [self caculateTotals];
    [self.tableView reloadData];
    [self.paySelectView hide];
    
}

#pragma mark - UITableViewDelegate&&UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
    return [self.dataArray[section] count];
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
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:path.section] withRowAnimation:UITableViewRowAnimationFade];
//            [weakSelf caculateTotalPriceInSection:indexPath.section];
            [weakSelf caculateTotals];
        };
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f*ALScreenScalWidth;
}

//#pragma mark - Secctionheader
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 60.0f;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    WS(weakSelf);
//    PalletSecctionView *p = [PalletSecctionView loadXibView];
//    p.palletNameL.text = [NSString stringWithFormat:@"托盘%i",(int)(section+1)];
//    p.TotalPriceL.text = [NSString stringWithFormat:@"%.2f",[self caculateTotalPriceInSection:section]];
//    p.selected = [self secctionDidAllSelected:section];
//    __weak typeof (PalletSecctionView *)weakP = p;
//    weakP.callBack = ^{
//        [weakSelf secctionChange:section isSelecte:!weakP.selected];
//    };
//    return p;
//}
/**
 * 判断该区域是否 全选择状态
 */
- (BOOL)secctionDidAllSelected:(NSInteger)section
{
    BOOL isSelected = YES;
    NSArray *arr = self.dataArray[section];
    for (palletCellModel *model in arr) {
        if (model.isSelected == NO) {
            isSelected = NO;
            break;
        }
    }
    return isSelected;
}
/**
 * 点击托盘按钮 取消或全选 section
 */
- (void)secctionChange:(NSInteger )section isSelecte:(BOOL)selected
{
    NSArray *arr = self.dataArray[section];
    for (palletCellModel *model in arr) {
        model.isSelected = selected;
    }
    [self caculateTotalPriceInSection:section];
    [self caculateTotals];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
}

/**
 * 计算区域价格 section
 */
- (CGFloat)caculateTotalPriceInSection:(NSInteger)section
{
    CGFloat total = 0.0f;
    NSArray *arr = self.dataArray[section];
    for (palletCellModel *model in arr) {
        if (model.isSelected) {
            total += (model.unit_price*model.quantity)/100.0f;
        }
    }
    return total;
}
/**
 * 计算全部物品总价
 */
- (void)caculateTotals
{
    CGFloat total = 0.0f;
    for (int i = 0; i<_dataArray.count; i++) {
        total += [self caculateTotalPriceInSection:i];
    }
    _totalPriceL.text = [NSString stringWithFormat:@"￥%.2f",total];
    self.paySelectView.priceL.text = [NSString stringWithFormat:@"结算价：￥%.2f",total];
}

@end
