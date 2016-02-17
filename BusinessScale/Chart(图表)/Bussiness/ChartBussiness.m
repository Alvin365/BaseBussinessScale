//
//  ChartBussiness.m
//  BusinessScale
//
//  Created by Alvin on 16/1/11.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "ChartBussiness.h"

@interface ChartBussiness()
/**
 * 周、月 数据
 */
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, assign) NSInteger i;
@property (nonatomic, copy) void(^returnBlock)(NSArray *array);

/**
 * 年数据
 */
@property (nonatomic, assign) NSInteger month;
@property (nonatomic, strong) NSMutableArray *yearDatas;
@property (nonatomic, copy) void(^returnMonthBlock)(NSArray *array);

@end

@implementation ChartBussiness

- (instancetype)init
{
    if (self = [super init]) {
        _minPrice = 0.0f;
        _maxPrice = 0.0f;
        _minDate = [[NSDate date] copy];
        _maxDate = [[NSDate date] copy];
        _month = 1;
        _yearDatas = [NSMutableArray array];
        _i = 0;
        _array = [NSMutableArray array];
        _returnBlock = nil;
    }
    return self;
}

- (void)setDayDataReturnBlock:(void (^)(NSArray *))block
{
    _returnBlock = nil;
    _returnBlock = [block copy];
}

- (void)setMonthDataReturnBlock:(void (^)(NSArray *))block
{
    _returnMonthBlock = nil;
    _returnMonthBlock = [block copy];
}

/**
 * 某天的总价格
 */
- (void)chartDatasBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate completedBlock:(void (^)(CGFloat payPrice))block
{
    [[SaleTable getUsingLKDBHelper]search:[SaleTable class] where:[NSString stringWithFormat:@"ts>'%.f' and ts<'%.f' and mac='%@' and uid='%@'",beginDate.zeroTime.timeStempString,endDate.dayEndTime.timeStempString,[ScaleTool scale].mac?[ScaleTool scale].mac:@"fsd",[AccountTool account].ID] orderBy:nil offset:0 count:0 callback:^(NSMutableArray *array) {
        CGFloat payPrice = 0.0f;
        for (SaleTable *salT in array) {
            payPrice += salT.paid_fee/100.0f;
        }
        if (_minPrice-payPrice>=0.0f) {
            _minPrice = payPrice;
            _minDate = [beginDate copy];
        }
        if (payPrice-_maxPrice >=0.0f ) {
            _maxPrice = payPrice;
            _maxDate = [beginDate copy];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(payPrice);
            }
        });
    }];

}
/**
 * 某开始时间  到结束天数的范围
 */
- (void)chartDatasBeginDate:(NSDate *)beginDate dayCount:(NSInteger )days
{
    if (_i == days-1) {
        ALLog(@"%@",[self.array copy]);
        _returnBlock([self.array copy]);
        _i=0;
        [self.array removeAllObjects];
        return;
    }
    [self chartDatasBeginDate:beginDate endDate:beginDate completedBlock:^(CGFloat payPrice) {
        [self.array addObject:@(payPrice)];
        [self chartDatasBeginDate:[beginDate dateByAddingDays:1] dayCount:days];
        _i++;
    }];
}

- (void)chartDatasYear:(NSDate *)yearDate
{
    WS(weakSelf);
    NSDate *beginDate = [NSDate dateWithYear:yearDate.year Month:_month Day:1];
    [self chartDatasBeginDate:beginDate dayCount:[beginDate numberOfDaysInCurrentMonth]];
    [self setDayDataReturnBlock:^(NSArray *array) {
        CGFloat total = 0.0f;
        for (NSNumber *num in array) {
            total += [num floatValue];
        }
        if (weakSelf.minMonthPrice-total>=0.0f) {
            weakSelf.minMonthPrice = total;
            weakSelf.minMonth = beginDate;
        }
        if (weakSelf.maxMonthPrice-total<=0.0f) {
            weakSelf.maxMonthPrice = total;
            weakSelf.maxMonth = beginDate;
        }
        [weakSelf.yearDatas addObject:@(total)];
        weakSelf.month ++;
        if (weakSelf.month>12) {
            if (weakSelf.returnMonthBlock) {
                weakSelf.returnMonthBlock(weakSelf.yearDatas);
            }
            weakSelf.month = 1;
            return;
        }
        [weakSelf chartDatasYear:yearDate];
    }];
    
}

@end
