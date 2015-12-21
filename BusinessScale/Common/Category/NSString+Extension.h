//
//  NSString+Extension.h
//  showTalence
//
//  Created by Alvin on 15/5/6.
//  Copyright (c) 2015年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
/** 根据名字返回拼音*/
+ (NSString*) getKeyByName:(NSString*)name;

+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)timeHoursFromDate:(NSDate *)date;
/** 是否包含Emoji表情*/
+ (BOOL)stringContainsEmoji:(NSString *)string;
/** 是否是汉字*/
- (BOOL)isChinese;

- (CGSize)bundingWithSize:(CGSize)size Font:(CGFloat)font;

- (BOOL)isEqualIgnoreCapitalToString:(NSString *)aString;
/** jason转字典*/
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString *)converDateStringToString:(NSString *)string;
@end
