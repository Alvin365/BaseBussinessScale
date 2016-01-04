//
//  NSDate+ALCalendar.m
//  showTalence
//
//  Created by Alvin on 15/5/19.
//  Copyright (c) 2015年 Alvin. All rights reserved.
//

#import "NSDate+ALCalendar.h"

@implementation NSDate (ALCalendar)

- (NSUInteger)numberOfDaysInCurrentMonth
{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
}

- (NSDate *)firstDayOfCurrentMonth
{
    NSDate *startDate = nil;
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit startDate:&startDate interval:NULL forDate:self];
    NSAssert1(ok, @"Failed to calculate the first day of the month based on %@", self);
    return startDate;
}

- (NSUInteger)weeklyOrdinality
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
}

- (NSUInteger)numberOfWeeksInCurrentMonth
{
    NSUInteger weekday = [[self firstDayOfCurrentMonth] weeklyOrdinality];
    
    NSUInteger days = [self numberOfDaysInCurrentMonth];
    NSUInteger weeks = 0;
    
    if (weekday > 1) {
        weeks += 1, days -= (7 - weekday + 1);
    }
    
    weeks += days / 7;
    weeks += (days % 7 > 0) ? 1 : 0;
    
    return weeks;
}

+ (NSDate*)convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

//输入的日期字符串形如：@"1992-05-21 13:08:08"

+ (NSDate *)dateFromString:(NSString *)dateString
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
    
}

//yyyy-MM-dd HH:mm:ss
+ (NSDate *)dateFromString:(NSString *)dateString Format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: format];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}
+ (NSDate *)dateFromStringYYMMDD:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

-(NSString *)getDateStringByFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *currentDateStr = [dateFormatter stringFromDate:self];
    return currentDateStr;
}

+ (NSDate *)getWeekFirstDate:(NSDate *)inputDate {
    int dayOfWeek = [DateUtil weekdayFromDate:inputDate];
    if (dayOfWeek == 7) {
        return inputDate;
    } else {
        NSTimeInterval secondsPerDay1 = 24*60*60*(-dayOfWeek);
        NSDate *firstDate = [inputDate dateByAddingTimeInterval:secondsPerDay1];
        return firstDate;
    }
}
/// 获得指定日期所在周最后一天的字符串(周六为最后一天) eg:2015-05-16 23:59:59
+(NSDate *)getWeekLastDate:(NSDate *)inputDate {
    int dayOfWeek = [DateUtil weekdayFromDate:inputDate];
    if (dayOfWeek == 7) {
        NSTimeInterval secondsPerDay1 = 24*60*60*6;
        NSDate *lastDate = [inputDate dateByAddingTimeInterval:secondsPerDay1];
        return lastDate;
    } else {
        NSTimeInterval secondsPerDay1 = 24*60*60*(6-dayOfWeek);
        NSDate *firstDate = [inputDate dateByAddingTimeInterval:secondsPerDay1];
        return firstDate;
    }
}

+ (int)weekdayFromDate:(NSDate*)inputDate {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    //    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    //    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    if (theComponents.weekday == 1) {
        return 7;
    }
    return (int)theComponents.weekday - 1;
}

@end
