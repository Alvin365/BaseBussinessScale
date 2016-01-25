//
//  ChartViewController.m
//  BusinessScaleBase
//
//  Created by Alvin on 15/12/15.
//  Copyright © 2015年 chipsea. All rights reserved.
//

#import "ChartViewController.h"
#import "BEMSimpleLineGraphView.h"
#import "ALDateView.h"
#import "Chart.h"
#import "ALInComeView.h"
#import "LevelView.h"
#import "ChartBussiness.h"
@interface ChartViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UISegmentedControl *segMent;
@property (nonatomic, strong) ALDateView *dateL;
@property (nonatomic, strong) Chart *chartView;

@property (nonatomic, strong) ALInComeView *totalIncomeView;
@property (nonatomic, strong) ALInComeView *averageIncomeView;
@property (nonatomic, strong) LevelView *mostLevel; // 最高
@property (nonatomic, strong) LevelView *leastLevel; // 最低

@property (nonatomic, copy) NSDate *weekBegin;
@property (nonatomic, copy) NSDate *monthBegin;
@property (nonatomic, copy) NSDate *yearBegin;


@end

@implementation ChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildView];
    [self datas];
}

- (void)buildView
{
    WS(weakSelf);
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -20, screenWidth, screenHeight-49+20)];
    _scrollView.bounces = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    _segMent = [[UISegmentedControl alloc]initWithItems:@[@"周报表",@"月报表",@"年报表"]];
    _segMent.selectedSegmentIndex = 0;
    _segMent.frame = CGRectMake(30, 30, screenWidth-60, 35);
    _segMent.layer.cornerRadius = 7;
    _segMent.backgroundColor = ALNavBarColor;
    _segMent.tintColor = [UIColor whiteColor];
    _segMent.layer.borderColor = [UIColor whiteColor].CGColor;
    _segMent.layer.borderWidth = 0.7;
    _segMent.layer.masksToBounds = YES;
    [_segMent addTarget:self action:@selector(segMentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segMent];
    
    _dateL = [ALDateView loadXibView];
    _dateL.frame = CGRectMake(40, _segMent.bottom+10, screenWidth-80, 40);
    _dateL.callBack = ^(DateViewDirection direction){
        [weakSelf dateChangedEvent:direction];
    };
    [self.view addSubview:_dateL];
    
    _chartView = [[Chart alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 338)];
    [_scrollView addSubview:_chartView];
    
    _totalIncomeView = [ALInComeView loadXibIncomeView];
    _totalIncomeView.frame = CGRectMake(0, _chartView.bottom, screenWidth/2.0f, 110);
    [_scrollView addSubview:_totalIncomeView];
    
    _averageIncomeView = [ALInComeView loadXibIncomeView];
    _averageIncomeView.frame = CGRectMake(_totalIncomeView.right, _totalIncomeView.y, screenWidth/2.0f, 110);
    [_scrollView addSubview:_averageIncomeView];
    
    UILabel *sep = [[UILabel alloc]initWithFrame:CGRectMake(0, _averageIncomeView.bottom-ALSeparaLineHeight, screenWidth, ALSeparaLineHeight)];
    sep.backgroundColor = separateLabelColor;
    [_scrollView addSubview:sep];
    
    _mostLevel = [[LevelView alloc]initWithFrame:CGRectMake(0, _totalIncomeView.bottom, screenWidth/2.0f, 100)];
    _mostLevel.levelFlag.text = @"最高";
    _mostLevel.levelL.text = @"周一";
    _mostLevel.price.text = @"750";
    _mostLevel.globalColor = Color(255, 102, 0, 1);
    [_scrollView addSubview:_mostLevel];
    
    _leastLevel = [[LevelView alloc]initWithFrame:CGRectMake(_mostLevel.right, _totalIncomeView.bottom, screenWidth/2.0f, 100)];
    _leastLevel.levelFlag.text = @"最低";
    _leastLevel.levelL.text = @"周三";
    _leastLevel.price.text = @"80";
    _leastLevel.globalColor = Color(87, 163, 217, 1);
    [_scrollView addSubview:_leastLevel];
    
    UILabel *sep2 = [[UILabel alloc]initWithFrame:CGRectMake(0, _leastLevel.bottom-ALSeparaLineHeight, screenWidth, ALSeparaLineHeight)];
    sep2.backgroundColor = separateLabelColor;
    [_scrollView addSubview:sep2];
    
    UILabel *sep3 = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2.0f, _totalIncomeView.y, ALSeparaLineHeight, _totalIncomeView.height+_mostLevel.height)];
    sep3.backgroundColor = separateLabelColor;
    [_scrollView addSubview:sep3];
    
    
    CGFloat contentH = _leastLevel.bottom+10;
    _scrollView.contentSize = CGSizeMake(0, contentH>_scrollView.height?contentH:_scrollView.height+10);
    
    _totalIncomeView.title.text = @"本周总收入";
    _averageIncomeView.title.text = @"日平均收入";
}

- (void)datas
{
    [self selectDate:nil];
}

- (void)selectDate:(NSDate *)beginDate
{
    NSInteger days = 0;
    if (self.segMent.selectedSegmentIndex==0) {
        if (!_weekBegin) {
            _weekBegin = [NSDate getWeekFirstDate:[NSDate date]];
            beginDate = [_weekBegin copy];
        }
        days = 7;
    }else if (self.segMent.selectedSegmentIndex==1){
        if (!_monthBegin) {
            _monthBegin = [NSDate dateWithYear:[NSDate date].year Month:[NSDate date].month Day:1];
            beginDate = [_monthBegin copy];
        }
        days = [beginDate numberOfDaysInCurrentMonth];
    }else{
        if (!_yearBegin) {
            _yearBegin = [NSDate dateWithYear:[NSDate date].year Month:1 Day:1];
            beginDate = [_yearBegin copy];
        }
        [self dateLabelTitle];
        days = 12;
    }
    [self dateLabelTitle];
    [self chartDatasBeginDate:beginDate totalDays:days];
}
/**
 * 周和月的数据
 */
- (void)chartDatasBeginDate:(NSDate *)beginDate totalDays:(NSInteger )days
{
    ChartBussiness *bussiness = [[ChartBussiness alloc]init];
    __weak typeof (ChartBussiness *)weakBussiness = bussiness;
    void (^block) (NSArray *) = ^(NSArray *array){
        __strong typeof (ChartBussiness *)strongBu = weakBussiness;
        CGFloat total = 0.0f;
        CGFloat aver = 0.0f;
        for (NSNumber *num in array) {
            total += [num floatValue];
        }
        aver = total/days;
        dispatch_async(dispatch_get_main_queue(), ^{
            _chartView.dataSource = array;
            self.totalIncomeView.priceL.text = [NSString stringWithFormat:@"%.2f",total];
            self.averageIncomeView.priceL.text = [NSString stringWithFormat:@"%.2f",aver];
            [self topAndLowState:strongBu];
            [self.mostLevel setNeedsLayout];
            [self.leastLevel setNeedsLayout];
        });
    };
    
    if (self.segMent.selectedSegmentIndex == 2) {
        [bussiness setMonthDataReturnBlock:^(NSArray *array) {
            block(array);
        }];
        [bussiness chartDatasYear:beginDate];
    }else{
        [bussiness setDayDataReturnBlock:^(NSArray *array) {
            block(array);
        }];
        [bussiness chartDatasBeginDate:beginDate dayCount:days];
    }
}

#pragma mark - action
- (void)segMentValueChanged:(UISegmentedControl *)seg
{
    _chartView.chartType = (ChartType)(seg.selectedSegmentIndex!=0);
    if (seg.selectedSegmentIndex == 0) {
        _totalIncomeView.title.text = @"本周总收入";
        _averageIncomeView.title.text = @"日平均收入";
        _chartView.chartType = ChartTypeBar;
        [self selectDate:_weekBegin];
    }else if (seg.selectedSegmentIndex == 1){
        _totalIncomeView.title.text = @"本月总收入";
        _averageIncomeView.title.text = @"日平均收入";
        _chartView.chartType = ChartTypeLine;
        [self selectDate:_monthBegin];
    }else{
        _totalIncomeView.title.text = @"年度总收入";
        _averageIncomeView.title.text = @"月平均收入";
        _chartView.chartType = ChartTypeLine;
        [self selectDate:_yearBegin];
    }
}

- (void)dateChangedEvent:(DateViewDirection )direction
{
    BOOL canChanged = NO;
    NSDate *date = nil;
    if (self.segMent.selectedSegmentIndex == 0) {
        date = [_weekBegin copy];
        _weekBegin = direction==DateViewDirectionLeft?[_weekBegin dateBySubtractingDays:7]:[_weekBegin dateByAddingDays:7];
        canChanged = [_weekBegin isEarlierThanDate:[NSDate date]];
        if (!canChanged) {
            _weekBegin = date;
        }else{
            date = [_weekBegin copy];
        }
    }else if (self.segMent.selectedSegmentIndex == 1){
        date = [_monthBegin copy];
        NSInteger year = _monthBegin.year;
        NSInteger month = _monthBegin.month;
        if (direction == DateViewDirectionLeft) {
            if (month == 1) {
                year -= 1;
                month = 12;
            }else{
                month --;
            }
        }else{
            if (month == 12) {
                year += 1;
                month = 1;
            }else{
                month ++;
            }
        }
        _monthBegin = [NSDate dateWithYear:year Month:month Day:1];
        canChanged = _monthBegin.year<[NSDate date].year||((_monthBegin.month<=[NSDate date].month)&&(_monthBegin.year==[NSDate date].year));
        if (!canChanged) {
            _monthBegin = date;
        }else{
            date = [_monthBegin copy];
        }
    }else{
        date = [_yearBegin copy];
        _yearBegin = [NSDate dateWithYear:direction==DateViewDirectionLeft?_yearBegin.year-1:_yearBegin.year+1 Month:1 Day:1];
        canChanged = _yearBegin.year<=[NSDate date].year;
        if (!canChanged) {
            _yearBegin = date;
        }else{
            date = [_yearBegin copy];
        }
    }
    if (canChanged) {
        [self dateLabelTitle];
        [self selectDate:date];
    }else{
        [MBProgressHUD showMessage:@"没有数据"];
        return;
    }
}

#pragma mark - 
- (void)dateLabelTitle
{
    if (self.segMent.selectedSegmentIndex == 0) {
        NSDate *weekEnd = [_weekBegin dateByAddingDays:7];
        _dateL.dateL.text = [NSString stringWithFormat:@"%@~%@",[NSString stringWithFormat:@"%i/%i/%i",(int)_weekBegin.year,(int)_weekBegin.month,(int)_weekBegin.day],[NSString stringWithFormat:@"%i/%i/%i",(int)weekEnd.year,(int)weekEnd.month,(int)weekEnd.day]];
    }else if (self.segMent.selectedSegmentIndex == 1){
        _dateL.dateL.text = [NSString stringWithFormat:@"%i年%i月",(int)_monthBegin.year,(int)_monthBegin.month];
    }else{
        _dateL.dateL.text = [NSString stringWithFormat:@"%i年",(int)_yearBegin.year];
    }
    
}

#pragma mark - resetTop&Low Date //最高、最低
- (void)topAndLowState:(ChartBussiness *)bussiness
{
    if (self.segMent.selectedSegmentIndex == 0) {
        self.mostLevel.levelL.text = [NSString stringWithFormat:@"%@",bussiness.maxDate.chineaseWeekDay];
        self.leastLevel.levelL.text = [NSString stringWithFormat:@"%@",bussiness.minDate.chineaseWeekDay];
    }else if (self.segMent.selectedSegmentIndex == 1){
        self.mostLevel.levelL.text = [NSString stringWithFormat:@"%i/%i/%i",(int)bussiness.maxDate.year,(int)bussiness.maxDate.month,(int)bussiness.maxDate.day];
        self.leastLevel.levelL.text = [NSString stringWithFormat:@"%i/%i/%i",(int)bussiness.minDate.year,(int)bussiness.minDate.month,(int)bussiness.minDate.day];
    }else{
        self.mostLevel.levelL.text = [NSString stringWithFormat:@"%i/%i",(int)bussiness.maxMonth.year,(int)bussiness.maxMonth.month];
        self.leastLevel.levelL.text = [NSString stringWithFormat:@"%i/%i",(int)bussiness.minMonth.year,(int)bussiness.minMonth.month];
        self.mostLevel.price.text = [NSString stringWithFormat:@"%.2f",bussiness.maxMonthPrice];
        self.leastLevel.price.text = [NSString stringWithFormat:@"%.2f",bussiness.minMonthPrice];
        return;
    }
    
    self.mostLevel.price.text = [NSString stringWithFormat:@"%.2f",bussiness.maxPrice];
    self.leastLevel.price.text = [NSString stringWithFormat:@"%.2f",bussiness.minPrice];
}

@end
