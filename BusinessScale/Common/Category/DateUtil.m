//
//  DateUtil.m
//  btWeigh
//
//  Created by ChipSea on 15/5/14.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

/**
 *  将日期进行格式化后获得字符串 eg:yyyy-MM-dd HH:mm:ss
 *
 *  @param date 需要格式化的日期
 *
 *  @return 格式化的字符串
 */
+(NSString *)getDateString:(NSDate *)date {
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

/**
 *  将日期进行格式化后获得字符串 eg:yyyy年MM月dd日   HH:mm
 *
 *  @param date 需要格式化的日期
 *
 *  @return 格式化的字符串
 */
+(NSString *)getDateString3:(NSDate *)date {
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat: @"yyyy年M月d日 hh:mm"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

/**
 *  将日期进行格式化后获得字符串 eg:yyyy-MM-dd
 *
 *  @param date 需要格式化的日期
 *
 *  @return 格式化的字符串
 */
+(NSString *)getDateString2:(NSDate *)date
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

/**
 *  将日期进行格式化后获得字符串 eg:M月d日
 *
 *  @param date 需要格式化的日期
 *
 *  @return 格式化的字符串
 */
+(NSString *)getDateString1:(NSDate *)date
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat: @"M月d日"];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

/**
 *  根据所给定的输出格式给出对应的日期字符串
 *
 *  @param date   日期
 *  @param format 日期格式
 *
 *  @return 输出的日期字符串
 */
+(NSString *)getDateString:(NSDate *)date byFormat:(NSString *)format {
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:format];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

/**
 *  根据制定字符串和制定的日期转换格式进行转换日期
 *
 *  @param dateString 日期字符串
 *  @param format     格式字符串
 *
 *  @return 获得日期
 */
+(NSDate *)dateFromString:(NSString *)dateString byFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: format];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

/**
 *  获得给定日期所在月份的天数
 *
 *  @param date 日期
 *
 *  @return 返回所给日期月份的天数
 */
+(int)getMonthDays:(NSDate *)date
{
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSDayCalendarUnit
                           inUnit:NSMonthCalendarUnit
                          forDate:date];
    return (int)days.length;
}

/// 根据生日获得过去的月数（用于宝宝数据）
+(int)getMonthPassed:(NSString*) date birthday:(NSString *)birthday
{
    int dateYear = [[date substringToIndex:4] intValue];
    int birthdayYear = [[birthday substringToIndex:4] intValue];
    int dateMonth = [[[date substringFromIndex:5] substringToIndex:2] intValue];
    int birthdayMonth = [[[birthday substringFromIndex:5] substringToIndex:2] intValue];
    return (dateYear - birthdayYear) * 12 + (dateMonth - birthdayMonth);
}

/// 根据最后生理日期获得过去的周数（用于准妈妈数据）
+(int)getWeekPassed:(NSString *)date refDate:(NSString *)refDate
{
    int dateYear = [[date substringToIndex:4] intValue];
    int birthdayYear = [[refDate substringToIndex:4] intValue];
    int dateWeek = [DateUtil weekFromDate:[DateUtil dateFromString1:date]];
    int periodWeek = [DateUtil weekFromDate:[DateUtil dateFromString1:refDate]];
    if (dateYear > birthdayYear) {
        dateWeek += 52;
    }
    return (dateWeek - periodWeek);
}

/// 获得自己产生的年龄
+(int)getAge:(NSString *)birthday
{
    int year = [[birthday substringWithRange:NSMakeRange(0, 4)] intValue];
    NSString *now = [DateUtil getDateString:[NSDate date]];
    int nowYear = [[now substringWithRange:NSMakeRange(0, 4)] intValue];
    //    NSLog(@"get Age : %d", nowYear - year + 1);
    return nowYear - year;
}

/**
 *  获得几个月后的今天
 *
 *  @param date 参照时间
 *  @param many 几个月(如果为正数,表示几个月后，如果为负数，表示几个月前)
 *
 *  @return 返回日期
 */
+(NSDate *)getDateAfterMonth:(NSDate *)date months:(int)many {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:0];
    [adcomps setMonth:many];
    [adcomps setDay:0];
    NSDate *newdate = [calendar dateByAddingComponents:adcomps toDate:date options:0];
    return newdate;
}

/// 获得指定日期是一周的周几
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

/// 获得指定日期是一年中的第几周
+(int)weekFromDate:(NSDate *)inputDate
{
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitWeekOfYear fromDate:inputDate];
    return (int)[components weekOfYear];
}

/// 获得指定日期是一个月中的几号
+ (int)dayFromDate:(NSDate*)inputDate
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSDayCalendarUnit fromDate:inputDate];
    return (int)[components day];
}

/// 获得指定日期是小时的数字
+ (int)hourFromDate:(NSDate *)inputDate
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSHourCalendarUnit fromDate:inputDate];
    return (int)[components hour];
}

/// 获得指定日期是月份的数字
+ (int)monthFromDate:(NSDate *)inputDate
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSMonthCalendarUnit fromDate:inputDate];
    return (int)[components month];
}

/// 获得指定日期是月份的数字
+ (int)yearFromDate:(NSDate *)inputDate
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSYearCalendarUnit fromDate:inputDate];
    return (int)[components year];
}

/// 获得指定日期所在周第一天的字符串(周日为第一天) eg:2015-05-10 00:00:00
+(NSString *)getWeekFirstDateStr:(NSDate *)inputDate {
    int dayOfWeek = [DateUtil weekdayFromDate:inputDate];
    if (dayOfWeek == 7) {
        return [NSString stringWithFormat:@"%@ 00:00:00", [DateUtil getDateString2:inputDate]];
    } else {
        NSTimeInterval secondsPerDay1 = 24*60*60*(-dayOfWeek);
        NSDate *firstDate = [inputDate dateByAddingTimeInterval:secondsPerDay1];
        return [NSString stringWithFormat:@"%@ 00:00:00", [DateUtil getDateString2:firstDate]];
    }
}
/// 获得指定日期所在周最后一天的字符串(周六为最后一天) eg:2015-05-16 23:59:59
+(NSString *)getWeekLastDateStr:(NSDate *)inputDate {
    int dayOfWeek = [DateUtil weekdayFromDate:inputDate];
    if (dayOfWeek == 7) {
        NSTimeInterval secondsPerDay1 = 24*60*60*6;
        NSDate *lastDate = [inputDate dateByAddingTimeInterval:secondsPerDay1];
        return [NSString stringWithFormat:@"%@ 23:59:59", [DateUtil getDateString2:lastDate]];
    } else {
        NSTimeInterval secondsPerDay1 = 24*60*60*(6-dayOfWeek);
        NSDate *firstDate = [inputDate dateByAddingTimeInterval:secondsPerDay1];
        return [NSString stringWithFormat:@"%@ 23:59:59", [DateUtil getDateString2:firstDate]];
    }
}

/// 获得指定日期的月份第一天的字符串 eg:2015-05-01 00:00:00
+(NSString *)getMonthFirstDateStr:(NSDate *)inputDate {
    NSString *monthStr = [DateUtil monthFromDate:inputDate] < 10 ?  [NSString stringWithFormat:@"0%d", [DateUtil monthFromDate:inputDate]] : [NSString stringWithFormat:@"%d", [DateUtil monthFromDate:inputDate]];
    NSString *returnStr = [NSString stringWithFormat:@"%d-%@-01 00:00:00", [DateUtil yearFromDate:inputDate], monthStr];
    return returnStr;
}
/// 获得指定日期的月份最后一天的字符串 eg:2015-05-31 23:59:59
+(NSString *)getMonthLastDateStr:(NSDate *)inputDate {
    NSString *monthStr = [DateUtil monthFromDate:inputDate] < 10 ?  [NSString stringWithFormat:@"0%d", [DateUtil monthFromDate:inputDate]] : [NSString stringWithFormat:@"%d", [DateUtil monthFromDate:inputDate]];
    NSString *returnStr = [NSString stringWithFormat:@"%d-%@-%d 23:59:59", [DateUtil yearFromDate:inputDate], monthStr, (int)[DateUtil getMonthDays:inputDate]];
    return returnStr;
}

+(NSString *)getSeasonFirstDateStr:(NSDate *)inputDate {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal
                               components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                               fromDate:inputDate];
    if (comps.month <=3)
    {
        comps.month =  1;
    }
    else if(comps.month<=6)
    {
        comps.month =  4;
    }
    else if(comps.month<=9)
    {
        comps.month =  7;
    }
    else if(comps.month<=12)
    {
        comps.month =  10;
    }
    
    comps.day = 1;
    NSDate *firstDay = [cal dateFromComponents:comps];
    return [DateUtil getMonthFirstDateStr:firstDay];
}

/// 获得指定日期的季度最后一天的字符串 eg:2015-06-31 23:59:59
+(NSString *)getSeasonLastDateStr:(NSDate *)inputDate {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal
                               components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                               fromDate:inputDate];
    if (comps.month <=3)
    {
        comps.month =  3;
    }
    else if(comps.month<=6)
    {
        comps.month =  6;
    }
    else if(comps.month<=9)
    {
        comps.month =  9;
    }
    else if(comps.month<=12)
    {
        comps.month =  12;
    }
    NSDate *firstDay = [cal dateFromComponents:comps];
    return [DateUtil getMonthLastDateStr:firstDay];
}

/// 将字符串转换成日期 fommater:yyyy-MM-dd HH:mm:ss
+ (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

/// 将字符串转换成日期 fommater:yyyy-MM-dd
+ (NSDate *)dateFromString1:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

/// 将字符串转换成日期 fommater:H:mm
+ (NSDate *)dateFromString2:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"H:mm"];
    NSDate *destDate = [dateFormatter dateFromString:dateString];
    return destDate;
}

/**
 *  见日期字符串 yyyy-MM-dd xx:xx:xx 转换为
    yyyy年MM月dd日 xx:xx
 */
+(NSString *)formatDateString:(NSString *)date{
    NSString *format;
    format = [date stringByReplacingCharactersInRange:NSMakeRange(4, 1) withString:@"年"];
    format = [format stringByReplacingCharactersInRange:NSMakeRange(7, 1) withString:@"月"];
    format = [format stringByReplacingCharactersInRange:NSMakeRange(10, 1) withString:@"日"];
    format = [format substringWithRange:NSMakeRange(0, 16)];

    return format;
}


@end
