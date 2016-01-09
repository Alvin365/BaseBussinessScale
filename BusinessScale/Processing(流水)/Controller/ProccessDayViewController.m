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
#import "CategoryCell.h"
#import "CategorySection.h"
@interface ProccessDayViewController ()<UITableViewDataSource,UITableViewDelegate,ALSelfDefineDatePickerViewDelegate>

@property (strong, nonatomic)  UITableView *tableView;
@property (nonatomic, strong) ProccessDayHeader *header;
@property (nonatomic, strong) NavGestureView *titleGestureView; // 透明导航栏手势事件
@property (nonatomic, strong) NSDate *titleDate;
@property (nonatomic, strong) ALDatePickerView *pickerView;
@property (nonatomic, strong) ALSelfDefineDatePickerView *otherPickView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *isOpens; // 区域是否打开
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy) NSDate *beginDate;
@property (nonatomic, copy) NSDate *endDate;

@end

@implementation ProccessDayViewController

- (ALSelfDefineDatePickerView *)otherPickView
{
    if (!_otherPickView) {
        _otherPickView = [[ALSelfDefineDatePickerView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _otherPickView.delegate = self;
        _otherPickView.type = self.tag;
    }
    return _otherPickView;
}

- (ALDatePickerView *)pickerView
{
    if (!_pickerView) {
        WS(weakSelf);
        _pickerView = [[ALDatePickerView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _pickerView.callBack = ^(NSDate *date){
            weakSelf.header.dateL.text = [NSString stringWithFormat:@"%i年%i月%i日",(int)date.year,(int)date.month,(int)date.day];
            [weakSelf selectDate:date endDate:date];
        };
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
        WS(weakSelf);
        _header = [ProccessDayHeader loadXibView];
        _header.frame = CGRectMake(0, 0, screenWidth, 214);
        _header.dateTag = _tag;
        _header.callBack = ^(NSInteger index){
            weakSelf.currentIndex = index;
            [weakSelf selectDate:weakSelf.beginDate endDate:weakSelf.endDate];
        };
    }
    return _header;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    self.navigationController.navigationBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = backGroudColor;
    self.navigationItem.titleView = self.titleGestureView;
    [self buildView];
    [self datas];
}

- (void)buildView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.tableHeaderView = self.header;
    [self.view addSubview:_tableView];
}

- (void)datas
{
    _dataArray = [NSMutableArray array];
    _isOpens = [NSMutableDictionary dictionary];
    [_isOpens setValue:@(YES) forKey:@"0"];
    NSDate *date = [NSDate date];
//    if (self.tag == ALProcessViewButtonTagDay) {
        [self selectDate:date endDate:date];
//    }
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![[_isOpens valueForKey:[NSString stringWithFormat:@"%i",(int)section]] boolValue]) {
        return 0;
    }
    if (!_currentIndex) {
        SaleTable *salT = _dataArray[section];
        return salT.items.count;
    }
    NSArray *arr = _dataArray[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIn = @"cellIn";
    static NSString *cellIden = @"cellIden2";
    if (!_currentIndex) {
        [_tableView registerNib:[UINib nibWithNibName:@"ProcessCell" bundle:nil] forCellReuseIdentifier:cellIn];
        ProcessCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIn];
        if (!indexPath.row) [cell showTopSeparaLine];
        if (indexPath.section < _dataArray.count) {
            SaleTable *salT = _dataArray[indexPath.section];
            if (indexPath.row < salT.items.count) {
                cell.item = salT.items[indexPath.row];
            }
        }
        return cell;
    }else{
        [_tableView registerNib:[UINib nibWithNibName:@"CategoryCell" bundle:nil] forCellReuseIdentifier:cellIden];
        CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
        if (indexPath.section < _dataArray.count) {
            NSArray *arr = _dataArray[indexPath.section];
            if (indexPath.row < arr.count) {
                cell.item = arr[indexPath.row];
                cell.sepT.hidden = indexPath.row;
            }
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_currentIndex) {
        return 70;
    }
    return 50.f;
}

#pragma mark -sectionView

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    @autoreleasepool {
        WS(weakSelf);
        if (!_currentIndex) {
            RecordSectionView *view = [RecordSectionView loadXibView];
            SaleTable *salT = _dataArray[section];
            CGFloat price = salT.paid_fee/100.0f;
            NSDate *date = [NSDate dateWithTimeIntervalInMilliSecondSince1970:salT.ts];
            view.callBack = ^{
                [weakSelf sectionEvent:section];
            };
            [view turnIntoProcessSecctionView];
            if (self.tag == ALProcessViewButtonTagDay) {
                view.dateL.text = [NSString stringWithFormat:@"%02d:%02d",(int)date.hour,(int)date.minute];
            }else if (self.tag == ALProcessViewButtonTagWeek){
                view.dateL.text = [NSString stringWithFormat:@"%i/%i/%i(%@)",(int)date.year,(int)date.month,(int)date.day,date.chineaseWeekDay];
            }
            
            view.priceL.text = [NSString stringWithFormat:@"%.2f元",price];
            return view;
        }else{
            CategorySection *view = [CategorySection loadXibView];
            view.dataArray = _dataArray[section];
            view.callBack = ^{
                [weakSelf sectionEvent:section];
            };
            return view;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!_currentIndex) {
        return 50;
    }
    return 70.f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat alpha = (scrollView.contentOffset.y)/(214.0f-64);
    UIColor *navigationBarColor = ALNavBarColor;
    Class className = NSClassFromString(@"_UINavigationBarBackground");
    ALLog(@"%.f",scrollView.contentOffset.y);
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass:className]) {
            view.backgroundColor = navigationBarColor;
            if (scrollView.contentOffset.y>214-64) {
                self.navigationItem.titleView = nil;
                self.title = @"日报表";
            }else{
                self.title = nil;
                if (!self.navigationItem.titleView) self.navigationItem.titleView = self.titleGestureView;
            }
            view.alpha = alpha;
            break;
        }
    }
    if (scrollView.contentOffset.y>150) {
        _tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    }else{
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
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

#pragma mark -ALSelfDefineDatePickerViewDelegate
- (void)monthPickCallBackDate:(NSDate *)date
{
    NSInteger days = [date numberOfDaysInCurrentMonth];
    NSDate *endDate = [date dateByAddingDays:days];
    [self selectDate:date endDate:endDate];
}

- (void)weekPickCallBackBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate
{
    [self selectDate:beginDate endDate:endDate];
}

#pragma mark - selectEvent  日期选择触发事件
- (void)selectDate:(NSDate *)beginDate endDate:(NSDate *)endDate
{
    [self.progressHud show:YES];
    _beginDate = beginDate;
    _endDate = endDate;
    if (!_currentIndex) {
        [self datasAccordingTime:beginDate endDate:endDate];
    }else{
        [self datasAccordingCategery:beginDate endDate:endDate];
    }
}
/**
 * 按时间查看
 */
- (void)datasAccordingTime:(NSDate *)beginDate endDate:(NSDate *)endDate
{
    [[SaleTable getUsingLKDBHelper]search:[SaleTable class] where:[NSString stringWithFormat:@"ts>%.2f and ts<%.2f",beginDate.zeroTime.timeStempString,endDate.dayEndTime.timeStempString] orderBy:nil offset:0 count:1000 callback:^(NSMutableArray *array) {
        ALLog(@"%@",array);
        CGFloat totalPrice = 0.0f;
        CGFloat payPrice = 0.0f;
        [_dataArray removeAllObjects];
        if (self.tag == ALProcessViewButtonTagDay) { // 天
            for (SaleTable *salT in array) {
                totalPrice += salT.total_fee/100.0f;
                payPrice += salT.paid_fee/100.0f;
            }
            [_dataArray addObjectsFromArray:array];
        }else{
            NSDate *flagDate = nil;
            NSInteger i = 0;
            for (SaleTable *salT in array) { // 月与周的数据处理
                NSDate *date = [NSDate dateWithTimeIntervalInMilliSecondSince1970:salT.ts];
                if (![flagDate isTheSameDayWithDate:date]) {
                    flagDate = date;
                    NSMutableArray *arr =[NSMutableArray array];
                    SaleTable *tempSal = array[i];
                    NSInteger temTotal = tempSal.total_fee;
                    NSInteger paidTotal = tempSal.paid_fee;
                    for (SaleTable *sal in array) {
                        if ([flagDate isTheSameDayWithDate:[NSDate dateWithTimeIntervalInMilliSecondSince1970:sal.ts]]) {
                            tempSal.total_fee += sal.total_fee;
                            tempSal.paid_fee += sal.paid_fee;
                            [arr addObjectsFromArray:sal.items];
                        }
                    }
                    tempSal.items = arr;
                    tempSal.total_fee -= temTotal;
                    tempSal.paid_fee -= paidTotal;
                    totalPrice += tempSal.total_fee/100.0f;
                    payPrice += tempSal.paid_fee/100.0f;
                    [_dataArray addObject:tempSal];
                }
                i++;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressHud hide:YES];
            [self showHeaderDate];
            self.header.totalPriceL.attributedText = [ALCommonTool setAttrbute:[NSString stringWithFormat:@"%.2f",payPrice] andAttribute:[NSString stringWithFormat:@"(%.2f)",totalPrice] Color1:[UIColor whiteColor] Color2:[UIColor whiteColor] Font1:25 Font2:15];
            
            [self.tableView reloadData];
        });
    }];
}
/**
 * 按品类查看
 */
- (void)datasAccordingCategery:(NSDate *)beginDate endDate:(NSDate *)endDate
{
    [[SaleItem getUsingLKDBHelper]search:[SaleItem class] where:[NSString stringWithFormat:@"ts>%.2f and ts<%.2f",beginDate.zeroTime.timeStempString,endDate.dayEndTime.timeStempString] orderBy:@"title" offset:0 count:1000 callback:^(NSMutableArray *array) {
        ALLog(@"%@",array);
        CGFloat totalPrice = 0.0f;
        CGFloat payPrice = 0.0f;
        NSString *key = nil;
        [_dataArray removeAllObjects];
        for (SaleItem *item in array) {
            CGFloat price = item.unit_price*item.quantity/100.0f;
            if (![key isEqualToString:item.title]) {
                key = item.title;
                NSMutableArray *arr = [NSMutableArray array];
                for (SaleItem *item in array) {
                    if ([item.title isEqualToString:key]) {
                        [arr addObject:item];
                    }
                }
                [_dataArray addObject:arr];
            }
            totalPrice += price;
            payPrice += price*item.discount;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressHud hide:YES];
            [self showHeaderDate];
            self.header.totalPriceL.attributedText = [ALCommonTool setAttrbute:[NSString stringWithFormat:@"%.2f",payPrice] andAttribute:[NSString stringWithFormat:@"(%.2f)",totalPrice] Color1:[UIColor whiteColor] Color2:[UIColor whiteColor] Font1:25 Font2:15];
            
            [self.tableView reloadData];
        });
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
// 显示日期
- (void)showHeaderDate
{
    if (self.tag == ALProcessViewButtonTagDay) {
        [self dayHeader];
    }else if (self.tag == ALProcessViewButtonTagWeek){
        [self weekHeader];
    }else{
        [self monthHeader];
    }
}
/** 周的header日期显示*/
- (void)weekHeader
{
    NSString *beginStr = [NSString stringWithFormat:@"%i-%i-%i",(int)_beginDate.year,(int)_beginDate.month,(int)_beginDate.day];
    NSString *endStr = [NSString stringWithFormat:@"%i-%02d-%02d",(int)_endDate.year,(int)_endDate.month,(int)_endDate.day];
    self.header.dateL.text = [NSString stringWithFormat:@"%@~%@",beginStr,endStr];
}
/** 月*/
- (void)monthHeader
{
    self.header.dateL.text = [NSString stringWithFormat:@"%i年%i月",(int)_beginDate.year,(int)_beginDate.month];
}
/** 日*/
- (void)dayHeader
{
    self.header.dateL.text = [NSString stringWithFormat:@"%i年%i月%i日",(int)_beginDate.year,(int)_beginDate.month,(int)_beginDate.day];
}
@end
