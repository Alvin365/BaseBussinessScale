//
//  UnitTool.h
//  BusinessScale
//
//  Created by Alvin on 16/1/8.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const UnitGram;
extern NSString *const Unit50Gram;
extern NSString *const Unit500Gram;
extern NSString *const UnitKiloGram;

/**
 * 单位 g,两，斤，公斤
 */
typedef NS_ENUM(NSInteger, WeightUnit)
{
    WeightUnit_Gram = 1,
    WeightUnit_50Gram = 50,
    WeightUnit_500Gram = 500,
    WeightUnit_killoGram = 1000
};


@interface UnitTool : NSObject

+ (WeightUnit)defaultUnit;

/**
 * 将枚举单位转为字符串单位
 */

+ (NSString *)stringFromWeight:(WeightUnit)unit;

+ (WeightUnit)unitFromString:(NSString *)string;

@end
