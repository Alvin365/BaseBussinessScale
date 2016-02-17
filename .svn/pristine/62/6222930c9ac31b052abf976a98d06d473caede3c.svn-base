//
//  CsBtCommon.m
//  Commercial-Bluetooth
//
//  Created by ChipSea on 16/1/6.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "CsBtCommon.h"

NSString * const pinUserDefaultKey = @"user_def_pin_key";
NSString * const wDecimalPointUDKey = @"user_def_weight_decimal_point_key";
NSString * const uDecimalPointUDKey = @"user_def_unit_decimal_point_key";
NSString * const macUserDefaultKey = @"user_def_bound_mac";

@implementation CsBtCommon

+ (void)setBoundMac:(NSString *)mac {
    [[NSUserDefaults standardUserDefaults] setObject:mac forKey:macUserDefaultKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(NSString *)getBoundMac {
    return [[NSUserDefaults standardUserDefaults] objectForKey:macUserDefaultKey];
}

+(void)clearBoundMac {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:macUserDefaultKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(void) setPin:(NSString *)pin{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:pin forKey:pinUserDefaultKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(NSString *)getPin {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:pinUserDefaultKey];
}

+(void)clearPin {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:pinUserDefaultKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(void) setWeightDecimalPoint:(int)wDecimalPoint {
    [[NSUserDefaults standardUserDefaults] setInteger:wDecimalPoint forKey:wDecimalPointUDKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(int) getWeightDecimalPoint {
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:wDecimalPointUDKey];
}

+(void) clearWeightDecimalPoint {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:wDecimalPointUDKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(void) setUnitDecimalPoint:(int)uDecimalPoint {
    [[NSUserDefaults standardUserDefaults] setInteger:uDecimalPoint forKey:uDecimalPointUDKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

+(int) getUnitDecimalPoint {
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:uDecimalPointUDKey];;
}

+(void) clearUnitDecimalPoint {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:uDecimalPointUDKey];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
@end
