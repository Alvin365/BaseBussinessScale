//
//  SyncUnitPriceFrame.m
//  Commercial-Bluetooth
//
//  Created by ChipSea on 16/1/6.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "SyncUnitPriceFrame.h"

@implementation SyncUnitPriceFrame

/**
 *  根据产品代号、单价以及单位产生同步给硬件的帧数据
 *
 *  @param productId 产品代号
 *  @param unitPrice 单价
 *  @param unit      单位
 *
 *  @return 同步所有单价信息指令的帧数据
 */
-(instancetype)initWithProductId:(int)productId unitPrice:(float)unitPrice withUnit:(CsBtUnit)unit {
    self = [super init];
    if (self) {
        long long lUnitPrice = (long long )(unitPrice * 100);
        Byte bytes[] = {0xA5, 0x10, 0x07, 0x10, (Byte)((productId >> 8) & 0xFF), (Byte)(productId & 0xFF), (Byte)((lUnitPrice >> 16) & 0xFF), (Byte)((lUnitPrice >> 8) & 0xFF), (Byte)(lUnitPrice & 0xFF), unit, 0x00};
        self = [super initWithBytes:bytes length:11];
    }
    return self;
}

@end
