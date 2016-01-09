//
//  UnitTool.m
//  BusinessScale
//
//  Created by Alvin on 16/1/8.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "UnitTool.h"


NSString *const UnitGram = @"克";
NSString *const Unit50Gram = @"两";
NSString *const Unit500Gram = @"斤";
NSString *const UnitKiloGram = @"公斤";


@implementation UnitTool

+ (NSString *)stringFromWeight:(WeightUnit)unit
{
    NSDictionary *dic = @{@"1":UnitGram,@"50":Unit50Gram,@"500":Unit500Gram,@"1000":UnitKiloGram};
    return dic[[NSString stringWithFormat:@"%i",(int)unit]];
}

+ (WeightUnit)defaultUnit
{
    NSInteger unit = 0;
    if (![[NSUserDefaults standardUserDefaults]objectForKey:unitGlobal]) {
        unit = 500;
    }else{
        unit = [[[NSUserDefaults standardUserDefaults]objectForKey:unitGlobal] integerValue];
    }
    return unit;
}

+ (WeightUnit)unitFromString:(NSString *)string
{
    NSDictionary *dic = @{@"1":UnitGram,@"50":Unit50Gram,@"500":Unit500Gram,@"1000":UnitKiloGram};
    NSInteger i = 0;
    for (NSString *str in dic.allValues) {
        if (string == str) {
            break;
        }
        i++;
    }
    return [dic.allKeys[i] integerValue];
}

@end
