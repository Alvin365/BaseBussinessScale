//
//  NSString+Extension.m
//  showTalence
//
//  Created by Alvin on 15/5/6.
//  Copyright (c) 2015年 Alvin. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
+(NSString*) getKeyByName:(NSString*)name{
//    NSMutableArray * pinyinStr = [[NSMutableArray alloc] initWithCapacity:1];
//    //根据联系人姓名生成拼音
//    unichar key;
//    xm_string_to_pinyin(name, name.length, pinyinStr);
//    if (pinyinStr.count>0) {
//        key = [[pinyinStr objectAtIndex:0] characterAtIndex:0];
//    }
//    else
//        key = '#';
//    NSString *str = [NSString stringWithFormat:@"%c",key];
//    return [str uppercaseString];
    return nil;
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    return [format stringFromDate:date];
}

+ (NSString *)timeHoursFromDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [format stringFromDate:date];
}

- (BOOL)isChinese{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (CGSize)bundingWithSize:(CGSize)size Font:(CGFloat)font
{
    if (iOS7) {
        return  [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:font] forKey:NSFontAttributeName] context:nil].size;
    }else{
        return  [self sizeWithFont:[UIFont systemFontOfSize:font] constrainedToSize:size];
    }
}

- (BOOL)isEqualIgnoreCapitalToString:(NSString *)aString
{
    NSString *str1 = [self lowercaseString];
    NSString *str2 = [aString lowercaseString];
    return [str1 isEqualToString:str2];
}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    isEomji = YES;
                }
            }
        }
    }];
    return isEomji;
}
/** jason赚字典*/
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (NSString *)converDateStringToString:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate *destDate= [dateFormatter dateFromString:string];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *str = [outputFormatter stringFromDate:destDate];
    return str;
}

+ (NSString *)radom11BitString
{
    char data[32];
    
    for (int x=0;x<11;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    return [[NSString alloc] initWithBytes:data length:11 encoding:NSUTF8StringEncoding];
    
}
@end
