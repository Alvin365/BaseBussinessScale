//
//  CsBtCommon.h
//  Commercial-Bluetooth
//
//  Created by ChipSea on 16/1/6.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    CsBtUnitKg  = 0x00,
    CsBtUnitJin = 0x01,
    CsBtUnitLb  = 0x02
} CsBtUnit;

@interface CsBtCommon : NSObject

/**
 *  设定绑定后的设备Mac地址
 *  设定后该值的情况下广播情况下只接受该设备广播
 *
 *  @param mac mac地址
 */
+(void)setBoundMac:(NSString *)mac;

/**
 *  获得绑定后的设备Mac地址
 *
 *  @return mac地址
 */
+(NSString *)getBoundMac;

/**
 *  清空绑定后的mac地址
 */
+(void)clearBoundMac;

/**
 *  给蓝牙模块设置Pin值，用于绑定以及连接蓝牙
 *
 *  @param pin pin值
 */
+(void) setPin:(NSString *)pin;

/**
 *  获得pin值
 *
 *  @return pin值
 */
+(NSString *)getPin;

/**
 *  清除Pin值
 */
+(void)clearPin;

/**
 *  设置重量小数点位数
 *
 *  @param wDecimalPoint 重量小数点位数
 */
+(void) setWeightDecimalPoint:(int)wDecimalPoint;

/**
 *  获得重量小数点位数
 *
 *  @return 重量小数点位数
 */
+(int) getWeightDecimalPoint;

/**
 *  清空重量小数点位数
 */
+(void) clearWeightDecimalPoint;

/**
 *  设置金额小数点位数
 *
 *  @param uDecimalPoint 金额小数点位数
 */
+(void) setUnitDecimalPoint:(int)uDecimalPoint;

/**
 *  获得金额小数点位数
 *
 *  @return 金额小数点位数
 */
+(int) getUnitDecimalPoint;

/**
 *  清空金额小数点位数
 */
+(void) clearUnitDecimalPoint;

@end
