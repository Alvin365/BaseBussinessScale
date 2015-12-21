//
//  DateUtil.h
//  btWeigh
//
//  Created by Zhanglh on 15/5/14.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject

/**
*  将日期进行格式化后获得字符串 eg:yyyy-MM-dd HH:mm:ss
*
*  @param date 需要格式化的日期
*
*  @return 格式化的字符串
*/
+(NSString *)getDateString:(NSDate *)date;

/**
 *  将日期进行格式化后获得字符串 eg:M月d日
 *
 *  @param date 需要格式化的日期
 *
 *  @return 格式化的字符串
 */
+(NSString *)getDateString1:(NSDate *)date;

/**
 *  将日期进行格式化后获得字符串 eg:yyyy-MM-dd
 *
 *  @param date 需要格式化的日期
 *
 *  @return 格式化的字符串
 */
+(NSString *)getDateString2:(NSDate *)date;

/**
 *  将日期进行格式化后获得字符串 eg:yyyy年MM月dd日   HH:mm
 *
 *  @param date 需要格式化的日期
 *
 *  @return 格式化的字符串
 */
+(NSString *)getDateString3:(NSDate *)date;

/**
 *  根据所给定的输出格式给出对应的日期字符串
 *
 *  @param date   日期
 *  @param format 日期格式
 *
 *  @return 输出的日期字符串
 */
+(NSString *)getDateString:(NSDate *)date byFormat:(NSString *)format;

/**
 *  根据制定字符串和制定的日期转换格式进行转换日期
 *
 *  @param dateString 日期字符串
 *  @param format     格式字符串
 *
 *  @return 获得日期
 */
+(NSDate *)dateFromString:(NSString *)dateString byFormat:(NSString *)format;

/**
 *  获得给定日期所在月份的天数
 *
 *  @param date 日期
 *
 *  @return 返回所给日期月份的天数
 */
+(int)getMonthDays:(NSDate *)date;

/**
 *  根据生日获得对照日期过去的月数(用于宝宝数据)
 *
 *  @param date     对照日期
 *  @param birthday 生日
 *
 *  @return 过去的月份数
 */
+(int)getMonthPassed:(NSString*) date birthday:(NSString *)birthday;

/**
 *  根据对日照日期与最后生理周期获得过去的周数(用于准妈妈数据)
 *
 *  @param date       对照日期
 *  @param periodTime 最后生理周期
 *
 *  @return 过去的周数
 */
+(int)getWeekPassed:(NSString *)date refDate:(NSString *)refDate;

/**
 *  根据生日获得年龄
 *
 *  @param birthday 生日
 *
 *  @return 年龄
 */
+(int)getAge:(NSString *)birthday;
/**
 *  获得几个月后的今天
 *
 *  @param date 参照时间
 *  @param many 几个月(如果为正数,表示几个月后，如果为负数，表示几个月前)
 *
 *  @return 返回日期
 */
+(NSDate *)getDateAfterMonth:(NSDate *)date months:(int)many;

/// 获得指定日期是一周的周几
+ (int)weekdayFromDate:(NSDate*)inputDate;
/// 获得指定日期是一年中的第几周
+(int)weekFromDate:(NSDate *)inputDate;
/// 获得指定日期是一个月中的几号
+ (int)dayFromDate:(NSDate*)inputDate;
/// 获得指定日期是月份的数字
+ (int)monthFromDate:(NSDate *)inputDate;
+ (int)hourFromDate:(NSDate *)inputDate;

/// 获得指定日期所在周第一天的字符串(周日为第一天) eg:2015-05-10 00:00:00
+(NSString *)getWeekFirstDateStr:(NSDate *)inputDate;
/// 获得指定日期所在周最后一天的字符串(周六为最后一天) eg:2015-05-16 23:59:59
+(NSString *)getWeekLastDateStr:(NSDate *)inputDate;
/// 获得指定日期的月份第一天的字符串 eg:2015-05-01 00:00:00
+(NSString *)getMonthFirstDateStr:(NSDate *)inputDate;
/// 获得指定日期的月份最后一天的字符串 eg:2015-05-31 23:59:59
+(NSString *)getMonthLastDateStr:(NSDate *)inputDate;
/// 获得指定日期的季度第一天的字符串 eg:2015-03-01 00:00:00
+(NSString *)getSeasonFirstDateStr:(NSDate *)inputDate;
/// 获得指定日期的季度最后一天的字符串 eg:2015-06-31 23:59:59
+(NSString *)getSeasonLastDateStr:(NSDate *)inputDate;

/// 将字符串转换成日期 fommater:yyyy-MM-dd HH:mm:ss
+ (NSDate *)dateFromString:(NSString *)dateString;
/// 将字符串转换成日期 fommater:yyyy-MM-dd
+ (NSDate *)dateFromString1:(NSString *)dateString;
/// 将字符串转换成日期 fommater:H:mm
+ (NSDate *)dateFromString2:(NSString *)dateString;
/**
 *  见日期字符串 yyyy-MM-dd xx:xx:xx 转换为
 yyyy年MM月dd日 xx:xx
 */
+(NSString *)formatDateString:(NSString *)date;
@end
