//
//  ALLineChar.m
//  BusinessScale
//
//  Created by Alvin on 16/1/16.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "ALLineChar.h"
#import "BEMSimpleLineGraphView.h"

@interface ALLineChar()<BEMSimpleLineGraphDataSource,BEMSimpleLineGraphDelegate>

@property (nonatomic, strong) BEMSimpleLineGraphView *lineChart;
@property (nonatomic, strong) UILabel *noDataLabel;

@end

@implementation ALLineChar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setLineup];
    }
    return self;
}

- (void)setLineup
{
    _lineChart = [[BEMSimpleLineGraphView alloc]initWithFrame:self.bounds];
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0
    };
    _lineChart.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    _lineChart.colorTop = ALNavBarColor;
    _lineChart.colorBottom = ALNavBarColor;
    _lineChart.dataSource = self;
    _lineChart.delegate = self;
    _lineChart.animationGraphStyle = BEMLineAnimationNone;
//    _lineChart.autoScaleYAxis = NO;
    [self addSubview:_lineChart];
    
    _noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height/2.0f-10, self.width, 20)];
    _noDataLabel.text = @"暂无数据";
    _noDataLabel.hidden = YES;
    _noDataLabel.textAlignment = NSTextAlignmentCenter;
    _noDataLabel.textColor = [UIColor whiteColor];
    _noDataLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_noDataLabel];
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = [dataArray copy];
    [_lineChart reloadGraph];
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
    if ([[graph calculatePointValueSum] floatValue]==0.0f) {
        graph.hidden = YES;
        _noDataLabel.hidden = NO;
    }else{
        graph.hidden = NO;
        _noDataLabel.hidden = YES;
    }
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
