//
//  ChartBussiness.h
//  BusinessScale
//
//  Created by Alvin on 16/1/11.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartBussiness : NSObject

@property (nonatomic, assign) CGFloat minPrice;
@property (nonatomic, assign) CGFloat maxPrice;
@property (nonatomic, copy) NSDate *minDate; // 天
@property (nonatomic, copy) NSDate *maxDate;

@property (nonatomic, assign) CGFloat minMonthPrice;
@property (nonatomic, assign) CGFloat maxMonthPrice;
@property (nonatomic, copy) NSDate *minMonth;
@property (nonatomic, copy) NSDate *maxMonth;

/**
 * 周、月报表 array里是一天的数据统计
 */
- (void)setDayDataReturnBlock:(void(^)(NSArray *array))block;
/**
 * 开始时间 总天数 （周、月报表）
 */
- (void)chartDatasBeginDate:(NSDate *)beginDate dayCount:(NSInteger )days;

/** 年报表  
 * array里是每月的数据统计
 */

- (void)setMonthDataReturnBlock:(void(^)(NSArray *array))block;
- (void)chartDatasYear:(NSDate *)yearDate;


@end
