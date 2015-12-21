//
//  NSDate+ALCalendar.h
//  showTalence
//
//  Created by Alvin on 15/5/19.
//  Copyright (c) 2015年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ALCalendar)
- (NSUInteger)numberOfDaysInCurrentMonth;
- (NSDate *)firstDayOfCurrentMonth;
- (NSUInteger)weeklyOrdinality;
- (NSUInteger)numberOfWeeksInCurrentMonth;
/** 字符串转时间*/
+ (NSDate *)dateFromString:(NSString *)dateString;
/** 字符串转时间*/
+ (NSDate*)convertDateFromString:(NSString*)uiDate;

+ (NSDate *)dateFromString:(NSString *)dateString Format:(NSString *)format;

+ (NSDate *)dateFromStringYYMMDD:(NSString *)dateString;

- (NSString *)getDateStringByFormat:(NSString *)format;
@end
