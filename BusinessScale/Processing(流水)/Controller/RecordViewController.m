//
//  RecordViewController.m
//  BusinessScale
//
//  Created by Alvin on 15/12/17.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordHeader.h"
#import "RecordCell.h"
#import "RecordSectionView.h"
#import "ProcessBussiness.h"
@interface RecordViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic ,strong)  RecordHeader *header;
@property (nonatomic, strong) NoDataView *noDataView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *isOpens;
@property (nonatomic, copy) NSDate *beginDate;
@property (nonatomic, copy) NSDate *endDate;

@end

@implementation RecordViewController

- (NoDataView *)noDataView
{
    if (!_noDataView) {
        _noDataView = [NoDataView loadXibView];
        _noDataView.frame = CGRectMake(0, 130, screenWidth, screenHeight-130-64);
        _noDataView.backgroundColor = [UIColor whiteColor];
    }
    return _noDataView;
}

- (RecordHeader *)header
{
    if (!_header) {
        WS(weakSelf);
        _header = [RecordHeader loadXibView];
        _header.frame = CGRectMake(0, 0, screenWidth, 120);
        ALLog(@"%.2f",screenWidth);
        _header.callBack = ^(NSDate *date){
            [weakSelf selectDate:date];
        };
    }
    return _header;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFromXib];
    [self datas];
}

- (void)initFromXib
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 120, screenWidth, screenHeight-120-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"收入记录";
    [self.view addSubview:self.header];
    [self.view addSubview:_tableView];
}

- (void)datas
{
    _dataArray = [NSMutableArray array];
    NSDate *date = [NSDate date];
    _isOpens = [NSMutableDictionary dictionary];
    [_isOpens setValue:@(YES) forKey:@"0"];
    
    self.header.dateL.text = [NSString stringWithFormat:@"%i年%i月",(int)date.year,(int)date.month];
    [self selectDate:date];
}

#pragma mark - UITableViewDataSource&&UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellInden = @"cellInden";
    RecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellInden];
    if (!cell) {
        cell = [[RecordCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellInden];
    }
    if (indexPath.section < _dataArray.count) {
        NSArray *arr = _dataArray[indexPath.section];
        if (indexPath.row < arr.count) {
            cell.model = arr[indexPath.row];
            if (!indexPath.row) [cell showTopSeparaLine];
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![[_isOpens valueForKey:[NSString stringWithFormat:@"%i",(int)section]] boolValue]) {
        return 0;
    }
    NSArray *arr = _dataArray[section];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark -section
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WS(weakSelf);
    @autoreleasepool {
        RecordSectionView *view = [RecordSectionView loadXibView];
        view.frame = CGRectMake(0, 0, screenWidth, 55);
        NSArray *arr = _dataArray[section];
        SaleTable *salT = nil;
        if (arr) {
            salT = arr[0];
        }
        view.callBack = ^{
            [weakSelf sectionEvent:section];
        };
        NSDate *date = [NSDate dateWithTimeIntervalInMilliSecondSince1970:salT.ts];
        view.dateL.text = [NSString stringWithFormat:@"%i/%i/%i",(int)date.year,(int)date.month,(int)date.day];
        CGFloat totalP = 0.0f;
        CGFloat totals = 0.0f;
        for (SaleTable *s in arr) {
            totalP += s.paid_fee/100.0f;
            totals += s.total_fee/100.0f;
        }
        view.priceL.text = [NSString stringWithFormat:@"%@元",[ALCommonTool decimalPointString:totalP]];
        view.realPrice.text = [NSString stringWithFormat:@"%@元",[ALCommonTool decimalPointString:totals]];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55.0f;
}

- (void)selectDate:(NSDate *)date
{
    [self.progressHud show:YES];
    [ProcessBussiness recordDatasWithDate:date completedBlock:^(NSArray *dataArray, CGFloat payPrice) {
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:dataArray];
        if (!_dataArray.count) {
            [self.view addSubview:self.noDataView];
        }else{
            [self.noDataView removeFromSuperview];
        }
        [self.progressHud hide:YES];
        self.header.priceL.text = [NSString stringWithFormat:@"%@元",[ALCommonTool decimalPointString:payPrice]];
        
        [self.tableView reloadData];
    }];
}

#pragma mark - sectionHideOrShow 某区域是打开还是收藏
- (void)sectionEvent:(NSInteger)section
{
    BOOL isOpen = [[self.isOpens valueForKey:[NSString stringWithFormat:@"%i",(int)section]] boolValue];
    [self.isOpens setValue:@(!isOpen) forKey:[NSString stringWithFormat:@"%i",(int)section]];
    [self.tableView reloadData];
    if (!isOpen) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

@end
