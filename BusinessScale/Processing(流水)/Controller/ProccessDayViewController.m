//
//  ProccessDayViewController.m
//  BusinessScale
//
//  Created by Alvin on 15/12/16.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "ProccessDayViewController.h"
#import "ProccessDayHeader.h"
#import "NavGestureView.h"
#import "ALDatePickerView.h"
#import "ProcessCell.h"
#import "RecordSectionView.h"
#import "ProcessCell.h"
#import "ALSelfDefineDatePickerView.h"
@interface ProccessDayViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic)  UITableView *tableView;
@property (nonatomic, strong) ProccessDayHeader *header;
@property (nonatomic, strong) NavGestureView *titleGestureView; // 透明导航栏手势事件
@property (nonatomic, strong) NSDate *titleDate;
@property (nonatomic, strong) ALDatePickerView *pickerView;
@property (nonatomic, strong) ALSelfDefineDatePickerView *otherPickView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ProccessDayViewController

- (ALSelfDefineDatePickerView *)otherPickView
{
    if (!_otherPickView) {
        _otherPickView = [[ALSelfDefineDatePickerView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _otherPickView.type = self.tag;
    }
    return _otherPickView;
}

- (ALDatePickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[ALDatePickerView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _pickerView;
}

- (NavGestureView *)titleGestureView
{
    if (!_titleGestureView) {
        WS(weakSelf);
        _titleGestureView = [[NavGestureView alloc]initWithFrame:CGRectMake(0, 0, screenWidth-160, 40)];
        _titleGestureView.callBack = ^(NavGestureViewTag tag){
            if (weakSelf.tag == ALProcessViewButtonTagDay) {
                [weakSelf.pickerView show];
            }else{
                [weakSelf.otherPickView showAnimate:YES];
            }
        };
    }
    return _titleGestureView;
}

- (ProccessDayHeader *)header
{
    if (!_header) {
        _header = [ProccessDayHeader loadXibView];
        _header.frame = CGRectMake(0, 0, screenWidth, 214);
        _header.dateTag = _tag;
    }
    return _header;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    UIColor *navigationBarColor = ALNavBarColor;
    Class className = NSClassFromString(@"_UINavigationBarBackground");
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass:className]) {
            view.backgroundColor = navigationBarColor;
            view.alpha = 0;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
    UIColor *navigationBarColor = ALNavBarColor;
    Class className = NSClassFromString(@"_UINavigationBarBackground");
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass:className]) {
            view.backgroundColor = navigationBarColor;
            view.alpha = 1;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroudColor;
    [self buildView];
    [self buildNavItems];
    [self datas];
}

- (void)buildView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -64, screenWidth, screenHeight+64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"ProcessCell" bundle:nil] forCellReuseIdentifier:@"cellIn"];
    
    _tableView.tableHeaderView = self.header;
    [self.view addSubview:_tableView];
}

- (void)buildNavItems
{
    self.navigationItem.titleView = self.titleGestureView;
    switch (self.tag) {
        case ALProcessViewButtonTagDay:
        {
            self.header.dateL.text = @"2015年11月15日";
        }
            break;
        case ALProcessViewButtonTagWeek:
        {
            self.header.dateL.text = @"2015年11月15日~11月22日";
        }
            break;
        case ALProcessViewButtonTagMonth:
        {
            self.header.dateL.text = @"2015年11月";
        }
            break;
        default:
            break;
    }
}

- (void)datas
{
    _dataArray = [NSMutableArray array];
    for (int i = 0; i< 2; i++) {
        NSMutableArray *arr = [NSMutableArray array];
        for (int j = 0; j<10; j++) {
            SaleItem *sal = [[SaleItem alloc]init];
            if (j%2) {
                sal.title = @"牛肉(前腿)";
                sal.unit_price = 20;
                sal.quantity = 80;
                sal.unit = @"克";
                sal.icon = @"img/cn_img470.png";
            }else{
                sal.title = @"豆腐卷";
                sal.unit_price = 8;
                sal.quantity = 20;
                sal.unit = @"克";
                sal.icon = @"img/cn_img077.png";
            }
            [arr addObject:sal];
        }
        [_dataArray addObject:arr];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = _dataArray[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIn = @"cellIn";
    ProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIn];
    if (!indexPath.row) [cell showTopSeparaLine];
    if (indexPath.section < _dataArray.count) {
        NSArray *arr = _dataArray[indexPath.section];
        if (indexPath.row < arr.count) {
            cell.item = arr[indexPath.row];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

#pragma mark -sectionView

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    @autoreleasepool {
        RecordSectionView *view = [RecordSectionView loadXibView];
        [view turnIntoProcessSecctionView];
        view.dateL.text = @"09:30";
        view.priceL.text = [NSString stringWithFormat:@"%.2f元",[self caculateTotalPriceInSection:section]];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y>86) {
        return;
    }
    CGFloat alpha = (scrollView.contentOffset.y+128.0f)/214.0f;
    UIColor *navigationBarColor = ALNavBarColor;
    Class className = NSClassFromString(@"_UINavigationBarBackground");
    ALLog(@"%.f",scrollView.contentOffset.y);
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass:className]) {
            view.backgroundColor = navigationBarColor;
            if (scrollView.contentOffset.y+128.0f-214.0f>-60) {
                self.navigationItem.titleView = nil;
                self.title = @"日报表";
                view.alpha = alpha;
            }else{
                self.title = nil;
                view.alpha = 0;
                if (!self.navigationItem.titleView) self.navigationItem.titleView = self.titleGestureView;
            }
            break;
        }
    }
}
#pragma mark -点击换日期事件
- (void)changDateWithTag:(NavGestureViewTag )navTag
{
    NSDate *newDate = nil;
    NSInteger count = 0;
    NSString *begDate = nil;
    if (_tag == ALProcessViewButtonTagDay) {
        count = 1;
    }else if (_tag == ALProcessViewButtonTagWeek){
        count = 7;
    }else if (_tag == ALProcessViewButtonTagMonth){
        count = (NSInteger)[DateUtil getMonthDays:_header.date];
    }
    if (navTag == NavGestureViewClick_Right) {
        newDate = [_header.date dateByAddingDays:count];
    }else{
        newDate = [_header.date dateBySubtractingDays:count];
    }
    begDate = [NSString stringFromDate:newDate];
    begDate = [NSString converDateStringToString:begDate];
    _header.dateL.text = begDate;
    if (_tag == ALProcessViewButtonTagWeek) {
        NSString *endDate = [DateUtil getWeekLastDateStr:newDate];
        endDate = [endDate componentsSeparatedByString:@" "][0];
//        NSString *endString = [endDate getDateStringByFormat:@"MM月DD日"];
        endDate = [NSString converDateStringToString:endDate];
        _header.dateL.text = [NSString stringWithFormat:@"%@~%@",begDate,endDate];
    }else if (_tag == ALProcessViewButtonTagMonth){
        _header.dateL.text = [newDate getDateStringByFormat:@"yyyy年MM月"];
    }
    _header.date = newDate;
}

/**
 * 计算区域价格 section
 */
- (CGFloat)caculateTotalPriceInSection:(NSInteger)section
{
    CGFloat total = 0.0f;
    NSArray *arr = self.dataArray[section];
    for (SaleItem *model in arr) {
        total += (model.unit_price*model.quantity)/100.0f;
    }
    return total;
}

@end
