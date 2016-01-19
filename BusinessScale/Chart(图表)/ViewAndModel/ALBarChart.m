//
//  ALBarChart.m
//  BusinessScale
//
//  Created by Alvin on 16/1/16.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "ALBarChart.h"
#import "PNChart.h"

@interface ALBarChart()

@property (nonatomic) PNBarChart * barChart;

@end

@implementation ALBarChart

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.barChart = [[PNBarChart alloc] initWithFrame:self.bounds];
    self.barChart.backgroundColor = [UIColor clearColor];
    
    self.barChart.yChartLabelWidth = 20.0;
    self.barChart.chartMarginLeft = 20.0;
    self.barChart.chartMarginRight = 20.0;
    self.barChart.chartMarginTop = 5.0;
    self.barChart.chartMarginBottom = 10.0;
    self.barChart.barWidth = 30.0f;
    
    self.barChart.labelMarginTop = 5.0;
    self.barChart.showChartBorder = NO;
    self.barChart.showLabel = NO;
    [self.barChart setXLabels:@[@"2",@"3",@"4",@"5",@"2",@"3",@"4"]];
//    [self.barChart setYValues:@[@10.82,@1.88,@6.96,@33.93,@10.82,@1.88,@6.96]];
    [self.barChart setStrokeColors:@[Color(125, 170, 50, 1),Color(125, 170, 50, 1),Color(125, 170, 50, 1),Color(125, 170, 50, 1),Color(125, 170, 50, 1),Color(125, 170, 50, 1),Color(125, 170, 50, 1)]];
    self.barChart.isGradientShow = NO;
    self.barChart.isShowNumbers = NO;
    
    [self.barChart strokeChart];
    
    
    [self addSubview:self.barChart];
}

- (void)setArray:(NSArray *)array
{
    _array = [array copy];
    [self.barChart updateChartData:_array];
}

- (CGFloat)yMax
{
    return _barChart.yMaxValue;
}

- (CGFloat)yMin
{
    return _barChart.yMinValue;
}

@end
