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
@property (nonatomic, strong) UILabel *noDataLabel;

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
    UIColor *barColor = Color(125, 170, 50, 1);
    [self.barChart setStrokeColors:@[barColor,barColor,barColor,barColor,barColor,barColor,barColor]];
    self.barChart.isGradientShow = NO;
    self.barChart.isShowNumbers = NO;
    
//    [self.barChart strokeChart];
    [self addSubview:self.barChart];
    
    _noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height/2.0f-10, self.width, 20)];
    _noDataLabel.text = @"暂无数据";
    _noDataLabel.hidden = YES;
    _noDataLabel.textAlignment = NSTextAlignmentCenter;
    _noDataLabel.textColor = [UIColor whiteColor];
    _noDataLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_noDataLabel];
}

- (void)setArray:(NSArray *)array
{
    _array = [array copy];
    WS(weakSelf);
    [_barChart updateChartData:_array];
    _barChart.completedDrawBlock = ^{
        weakSelf.noDataLabel.hidden = weakSelf.barChart.yValueMax>0.0f;
    };
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
