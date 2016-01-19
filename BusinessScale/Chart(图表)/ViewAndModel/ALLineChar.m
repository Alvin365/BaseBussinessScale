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
    [self addSubview:_lineChart];
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
