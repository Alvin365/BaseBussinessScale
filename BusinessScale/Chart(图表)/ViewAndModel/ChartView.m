//
//  ChartView.m
//  BusinessScale
//
//  Created by Alvin on 16/1/10.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "ChartView.h"
#import "BEMSimpleLineGraphView.h"
#import "ChartBussiness.h"
@interface ChartView()<BEMSimpleLineGraphDataSource,BEMSimpleLineGraphDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segMent;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *totalView;
@property (weak, nonatomic) IBOutlet UIView *averageView;
@property (weak, nonatomic) IBOutlet UIView *mostView;
@property (weak, nonatomic) IBOutlet UIView *leastView;
@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UILabel *dateL;

@property (weak, nonatomic) IBOutlet UILabel *dayMoneyL;
@property (weak, nonatomic) IBOutlet UILabel *totalFlagL;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceFlagL;

@property (weak, nonatomic) IBOutlet UILabel *averageFlagL;
@property (weak, nonatomic) IBOutlet UILabel *averagePrice;
@property (weak, nonatomic) IBOutlet UILabel *averagePriceFlag;

@property (weak, nonatomic) IBOutlet UILabel *mostTopFlag;
@property (weak, nonatomic) IBOutlet UILabel *mostDate;
@property (weak, nonatomic) IBOutlet UILabel *mostPriceL;
@property (weak, nonatomic) IBOutlet UILabel *mostPriceFlag;


@property (weak, nonatomic) IBOutlet UILabel *leastFlag;
@property (weak, nonatomic) IBOutlet UILabel *leastDate;
@property (weak, nonatomic) IBOutlet UILabel *leastPriceL;
@property (weak, nonatomic) IBOutlet UILabel *leastPriceFlag;

@property (nonatomic, strong) BEMSimpleLineGraphView *curve;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSDate *beginDate;
@property (nonatomic, copy) NSDate *endDate;

@end

@implementation ChartView

- (BEMSimpleLineGraphView *)curve
{
    if (!_curve) {
        _curve = [[BEMSimpleLineGraphView alloc]initWithFrame:CGRectMake(0, _dateView.bottom+20, screenWidth, _topView.height-(_dateView.bottom+20))];
        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
        size_t num_locations = 2;
        CGFloat locations[2] = { 0.0, 1.0 };
        CGFloat components[8] = {
            1.0, 1.0, 1.0, 1.0,
            1.0, 1.0, 1.0, 0.0
        };
        
        // Apply the gradient to the bottom portion of the graph
        _curve.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
        _curve.colorTop = ALNavBarColor;
        _curve.colorBottom = ALNavBarColor;
        _curve.dataSource = self;
        _curve.delegate = self;
    }
    return _curve;
}

+ (instancetype)loadXibView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ChartView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    _topView.backgroundColor = ALNavBarColor;
    _segMent.backgroundColor = ALNavBarColor;
    _dayMoneyL.textColor = Color(125, 170, 50, 1);
    
    _totalFlagL.textColor = ALTextColor;
    _averageFlagL.textColor = ALTextColor;
    _totalPriceFlagL.textColor = ALNavBarColor;
    _totalPrice.textColor = ALNavBarColor;
    _averagePrice.textColor = ALNavBarColor;
    _averagePriceFlag.textColor = ALNavBarColor;
    
    _mostTopFlag.layer.cornerRadius = 10.0f;
    _mostTopFlag.layer.masksToBounds = YES;
    _mostTopFlag.backgroundColor = Color(255, 102, 0, 1);
    _mostDate.textColor = ALTextColor;
    _mostPriceFlag.textColor = Color(255, 102, 0, 1);
    _mostPriceL.textColor = Color(255, 102, 0, 1);
    
    _leastFlag.layer.cornerRadius = 10.0f;
    _leastFlag.layer.masksToBounds = YES;
    _leastFlag.backgroundColor = Color(87, 163, 217, 1);
     _leastDate.textColor = ALTextColor;
    _leastPriceFlag.textColor = Color(87, 163, 217, 1);
    _leastPriceL.textColor = Color(87, 163, 217, 1);;
    
    _totalView.backgroundColor = [UIColor whiteColor];
    _averageView.backgroundColor = [UIColor whiteColor];
    _mostView.backgroundColor = Color(243, 243, 243, 1);
    _leastView.backgroundColor = Color(243, 243, 243, 1);
    
    UILabel *sepM = [[UILabel alloc]initWithFrame:CGRectMake(0, _totalView.bottom, screenWidth, ALSeparaLineHeight)];
    sepM.backgroundColor = separateLabelColor;
    [self addSubview:sepM];
    
    UILabel *sepB = [[UILabel alloc]initWithFrame:CGRectMake(0, _mostView.bottom, screenWidth, ALSeparaLineHeight)];
    sepB.backgroundColor = separateLabelColor;
    [self addSubview:sepB];
    
    UILabel *sep = [[UILabel alloc]initWithFrame:CGRectMake(_totalView.right, _topView.bottom, ALSeparaLineHeight, _totalView.height+_mostView.height)];
    sep.backgroundColor = separateLabelColor;
    [self addSubview:sep];
    
    _segMent.layer.cornerRadius = 7;
    _segMent.layer.borderColor = [UIColor whiteColor].CGColor;
    _segMent.layer.borderWidth = 0.7;
    _segMent.layer.masksToBounds = YES;
    
    [_dateView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)]];
    
    [self datas];
    
}

#pragma mark - actions

- (IBAction)segChanged:(UISegmentedControl *)sender {
    [self selectDate:_beginDate endDate:_endDate];
    if (sender.selectedSegmentIndex == 0) {
        _totalFlagL.text = @"本周总收入";
    }else if (sender.selectedSegmentIndex == 1){
        _totalFlagL.text = @"本月总收入";
    }else{
        _totalFlagL.text = @"年度总收入";
    }
}

- (void)tapClick:(UIGestureRecognizer *)reconizer
{
    CGPoint point = [reconizer locationInView:reconizer.view];
//    RecordHeaderTag tag = point.x>=self.width/2.0f?RecordHeaderTag_Right:RecordHeaderTag_Left;
    if (point.x>=self.width/2.0f) {
        if (self.segMent.selectedSegmentIndex == 0) {
            [self selectDate:[_beginDate dateByAddingDays:7] endDate:[_endDate dateByAddingDays:7]];
        }else if (self.segMent.selectedSegmentIndex == 1){
            [self selectDate:[_endDate dateByAddingDays:1] endDate:_endDate];
        }else{
            [self selectDate:[NSDate dateWithYear:_beginDate.year+1 Month:1 Day:1] endDate:_endDate];
        }
    }else{
        if (self.segMent.selectedSegmentIndex == 0) {
            [self selectDate:[_beginDate dateBySubtractingDays:7] endDate:[_endDate dateBySubtractingDays:7]];
        }else if (self.segMent.selectedSegmentIndex == 1){
            [self selectDate:[_beginDate dateBySubtractingDays:1] endDate:_endDate];
        }else{
            [self selectDate:[NSDate dateWithYear:_beginDate.year+1 Month:1 Day:1] endDate:_endDate];
        }
    }
    if (self.segMent.selectedSegmentIndex == 0) {
        self.dateL.text = [NSString stringWithFormat:@"%i/%i/%i~%i/%i/%i",(int)_beginDate.year,(int)_beginDate.month,(int)_beginDate.day,(int)_endDate.year,(int)_endDate.month,(int)_endDate.day];
    }else if (self.segMent.selectedSegmentIndex == 1){
        self.dateL.text = [NSString stringWithFormat:@"%i年%02d月",(int)_beginDate.year,(int)_beginDate.month];
    }else{
        self.dateL.text = [NSString stringWithFormat:@"%i年",(int)_beginDate.year];
    }
}

- (void)datas
{
    _dataArray = [NSMutableArray array];
    self.segMent.selectedSegmentIndex = 0;
    NSDate *date = [NSDate date];
    [self addSubview:self.curve];
    [self.topView bringSubviewToFront:_dayMoneyL];
    [self selectDate:date endDate:date];
    _totalFlagL.text = @"本周总收入";
}

#pragma mark - dataBase
- (void)selectDate:(NSDate *)beginDate endDate:(NSDate *)endDate
{
    [_dataArray  removeAllObjects];
    if (self.segMent.selectedSegmentIndex == 0) {
        beginDate = [NSDate date];
        endDate = [NSDate date];
        _beginDate = [NSDate getWeekFirstDate:beginDate];
        _endDate = [NSDate getWeekLastDate:endDate];
    }else if (self.segMent.selectedSegmentIndex == 1){
        _beginDate = [NSDate dateWithYear:beginDate.year Month:beginDate.month Day:1];
        _endDate = [_beginDate dateByAddingDays:([beginDate numberOfDaysInCurrentMonth]-1)];
    }else{
        _beginDate = [NSDate dateWithYear:beginDate.year Month:1 Day:1];
        NSInteger daysCount = beginDate.year%4?364:365;
        _endDate = [_beginDate dateByAddingDays:daysCount];
    }
    ALLog(@"beginDate:%@ endDate:%@",_beginDate,_endDate);
    [self datasFromBase:_beginDate endDate:_endDate];
}

- (void)datasFromBase:(NSDate *)beginDate endDate:(NSDate *)endDate
{
    [ChartBussiness chartDatasBeginDate:beginDate endDate:endDate completedBlock:^(NSArray *dataArray) {
        ALLog(@"%@",dataArray);
        for (SaleTable *salT in dataArray) {
            [_dataArray addObject:@(salT.paid_fee/100.0f)];
        }
        [self.curve reloadGraph];
        self.totalPrice.text = [NSString stringWithFormat:@"%.2f",[[self.curve calculatePointValueSum] floatValue]];
        self.averagePrice.text = [NSString stringWithFormat:@"%.2f",[[self.curve calculatePointValueAverage] floatValue]];
        
        self.mostDate.text = [NSString stringWithFormat:@"%i",(int)[self.curve maxIndex]];
        self.leastDate.text = [NSString stringWithFormat:@"%i",(int)[self.curve minIndex]];
        self.mostPriceL.text = [NSString stringWithFormat:@"%.2f",[[self.curve calculateMaximumPointValue] floatValue]];
        self.leastPriceL.text = [NSString stringWithFormat:@"%.2f",[[self.curve calculateMinimumPointValue] floatValue]];
    }];
}

#pragma mark - SimpleLineGraph Data Source
- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[self.dataArray count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[self.dataArray objectAtIndex:index] doubleValue];
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    return 2;
}

//- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
//    
//    NSString *label = [self labelForDateAtIndex:index];
//    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
//}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
    
}

- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
    
}

- (void)lineGraphDidFinishLoading:(BEMSimpleLineGraphView *)graph {
   
}

//- (NSString *)labelForDateAtIndex:(NSInteger)index
//{
//    NSDate *date = self.dataArray[index];
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    df.dateFormat = @"MM/dd";
//    NSString *label = [df stringFromDate:date];
//    return label;
//}


@end
