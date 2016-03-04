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
    _dateL.callBack = ^(NSDate *date){
        [weakSelf selectDate:date];
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
    _dateL.type = DateViewTypeWeek;
    [self selectDate:[NSDate getWeekFirstDate:[NSDate date]]];
}

- (void)selectDate:(NSDate *)beginDate
{
    [self.progressHud show:YES];
    NSInteger days = 0;
    if (self.segMent.selectedSegmentIndex==0) {
        days = 7;
    }else if (self.segMent.selectedSegmentIndex==1){
        days = [beginDate numberOfDaysInCurrentMonth];
    }else{
        days = 12;
    }
    _dateL.currentSeletedDate = beginDate;
    [self chartDatasBeginDate:beginDate totalDays:days];
}
#pragma mark - 图标数据(本地数据库)
- (void)chartDatasBeginDate:(NSDate *)beginDate totalDays:(NSInteger )days
{
    ChartBussiness *bussiness = [[ChartBussiness alloc]init];
    __weak typeof (ChartBussiness *)weakBussiness = bussiness;
    /** 查询到数据 刷新UI事件*/
    void (^block) (NSArray *) = ^(NSArray *array){
        [self.progressHud hide:YES];
        __strong typeof (ChartBussiness *)strongBu = weakBussiness;
        CGFloat total = 0.0f;
        CGFloat aver = 0.0f;
        NSInteger count = 0;
        for (NSNumber *num in array) {
            total += [num floatValue];
            if ([num floatValue]>0) {
                count++;
            }
        }
        aver = count?total/count:0;
        dispatch_async(dispatch_get_main_queue(), ^{
            _chartView.dataSource = array;
            self.totalIncomeView.priceL.text = [ALCommonTool decimalPointString:total];
            self.averageIncomeView.priceL.text = [ALCommonTool decimalPointString:aver];
            [self.totalIncomeView setPriceShow:total!=0.0f];
            [self.averageIncomeView setPriceShow:aver!=0];
            
            [self topAndLowState:strongBu];
            [self.mostLevel setNeedsLayout];
            [self.leastLevel setNeedsLayout];
        });
    };
    
    if (self.segMent.selectedSegmentIndex == 2) {
        /** 年数据*/
        [bussiness setMonthDataReturnBlock:^(NSArray *array) {
            block(array);
        }];
        [bussiness chartDatasYear:beginDate];
    }else{
        /** 周、月数据*/
        [bussiness setDayDataReturnBlock:^(NSArray *array) {
            block(array);
        }];
        [bussiness chartDatasBeginDate:beginDate dayCount:days];
    }
}

#pragma mark - action
- (void)segMentValueChanged:(UISegmentedControl *)seg
{
    [self.progressHud show:YES];
    _chartView.chartType = (ChartType)(seg.selectedSegmentIndex!=0);
    _dateL.type = (DateViewType )self.segMent.selectedSegmentIndex;
    if (seg.selectedSegmentIndex == 0) {
        _totalIncomeView.title.text = @"本周总收入";
        _averageIncomeView.title.text = @"日平均收入";
        _chartView.chartType = ChartTypeBar;
        
        if (!_weekBegin) {
            _weekBegin = [NSDate getWeekFirstDate:[NSDate date]];
        }
        [self selectDate:_weekBegin];
    }else if (seg.selectedSegmentIndex == 1){
        _totalIncomeView.title.text = @"本月总收入";
        _averageIncomeView.title.text = @"日平均收入";
        _chartView.chartType = ChartTypeLine;
        
        if (!_monthBegin) {
            _monthBegin = [NSDate dateWithYear:[NSDate date].year Month:[NSDate date].month Day:1];
        }
        
        [self selectDate:_monthBegin];
    }else{
        _totalIncomeView.title.text = @"年度总收入";
        _averageIncomeView.title.text = @"月平均收入";
        _chartView.chartType = ChartTypeLine;
        
        if (!_yearBegin) {
            _yearBegin = [NSDate dateWithYear:[NSDate date].year Month:1 Day:1];
        }
        
        [self selectDate:_yearBegin];
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
        self.mostLevel.price.text = [ALCommonTool decimalPointString:bussiness.maxMonthPrice];
        self.leastLevel.price.text = [ALCommonTool decimalPointString:bussiness.minMonthPrice];
        [self.mostLevel setPriceShow:bussiness.maxMonthPrice!=0.0f];
        [self.leastLevel setPriceShow:bussiness.minMonthPrice!=0.0f];
        return;
    }
    self.mostLevel.price.text = [ALCommonTool decimalPointString:bussiness.maxPrice];
    self.leastLevel.price.text = [ALCommonTool decimalPointString:bussiness.minPrice];
    [self.mostLevel setPriceShow:bussiness.maxPrice!=0.0f];
    [self.leastLevel setPriceShow:bussiness.minPrice!=0.0f];
}

@end
