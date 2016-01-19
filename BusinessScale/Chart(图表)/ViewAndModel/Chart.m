//
//  Chart.m
//  BusinessScale
//
//  Created by Alvin on 16/1/16.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "Chart.h"
#import "ALBarChart.h"
#import "ALLineChar.h"
@interface Chart()

@property (nonatomic, strong) ALBarChart *barChart;
@property (nonatomic, strong) ALLineChar *lineChart;

@property (nonatomic, strong) UILabel *unitLabel;

@end

@implementation Chart

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = ALNavBarColor;
    
    _barChart = [[ALBarChart alloc]initWithFrame:CGRectMake(10, 110, screenWidth-20, 220)];
    [self addSubview:_barChart];
    
    _lineChart = [[ALLineChar alloc]initWithFrame:CGRectMake(10, 110, screenWidth-20, 220)];
    [self addSubview:_lineChart];
    _lineChart.hidden = YES;
    
    _unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.height-30, screenWidth, 20)];
    _unitLabel.text = @"元/天";
    _unitLabel.font = [UIFont systemFontOfSize:12];
    _unitLabel.textColor = Color(125, 170, 50, 1);
    [self addSubview:_unitLabel];
    
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = [dataSource copy];
    if (self.chartType == ChartTypeBar) {
        _barChart.array = _dataSource;
        _barChart.hidden = NO;
        _lineChart.hidden = YES;
    }else{
        _lineChart.dataArray = _dataSource;
        _lineChart.hidden = NO;
        _barChart.hidden = YES;
    }
}

- (CGFloat)yMax
{
    if (self.chartType == ChartTypeBar) {
        return self.barChart.yMax;
    }
    return 0;
}

- (CGFloat)yMin
{
    if (self.chartType == ChartTypeBar) {
        return self.barChart.yMin;
    }
    return 0;
}

@end
