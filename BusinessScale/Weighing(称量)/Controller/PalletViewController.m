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
@interface PalletViewController ()<UITableViewDataSource,UITableViewDelegate>
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
@property (nonatomic, assign) BOOL allSelected;

@end

@implementation PalletViewController

- (PayWaySelectView *)paySelectView
{
    if (!_paySelectView) {
        _paySelectView = [PayWaySelectView loadXibView];
        _paySelectView.frame = [UIScreen mainScreen].bounds;
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
    for (int i = 0; i< 2; i++) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int j = 0; j<10; j++) {
            palletCellModel *model = [[palletCellModel alloc]init];
            model.isSelected = YES;
            [arr addObject:model];
        }
        [_dataArray addObject:arr];
    }
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
    [self.tableView reloadData];
}

- (void)payMoney
{
    [self.paySelectView showAnimate:YES];
}

#pragma mark - UITableViewDelegate&&UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
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
    NSArray *arr = self.dataArray[indexPath.section];
    if (indexPath.row < arr.count) {
        cell.sepT.hidden = indexPath.row;
        cell.model = arr[indexPath.row];
        cell.callBack = ^(palletCell *cell){
            NSIndexPath *path = [tableView indexPathForCell:cell];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationFade];
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:path.section] withRowAnimation:UITableViewRowAnimationFade];
//            [weakSelf.tableView reloadData];
        };
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

#pragma mark - Secctionheader
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WS(weakSelf);
    PalletSecctionView *p = [PalletSecctionView loadXibView];
    p.selected = [self secctionDidAllSelected:section];
    __weak typeof (PalletSecctionView *)weakP = p;
    weakP.callBack = ^{
        [weakSelf secctionChange:section isSelecte:!weakP.selected];
    };
    return p;
}

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

- (void)secctionChange:(NSInteger )section isSelecte:(BOOL)selected
{
    NSArray *arr = self.dataArray[section];
    for (palletCellModel *model in arr) {
        model.isSelected = selected;
    }
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
}

@end
