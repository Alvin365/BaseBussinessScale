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
 *  根据产品代号和单价产生同步给硬件的帧数据
 *
 *  @param productId  产品代号
 *  @param unitPrice  单价
 *  @param productId1 产品代号
 *  @param unitPrice1 单价
 *  @param productId2 产品代号
 *  @param unitPrice2 单价
 *
 *  @return 同步所有单价信息指令的帧数据
 */
-(instancetype)initWithProductId:(int)productId unitPrice:(float)unitPrice productId1:(int)productId1 unitPrice1:(float)unitPrice1 productId2:(int)productId2 unitPrice2:(float)unitPrice2 {
    self = [super init];
    if (self) {
        long long lUnitPrice = (long long )(unitPrice * (pow(10, [CsBtCommon getUnitDecimalPoint])));
        long long lUnitPrice1 = (long long )(unitPrice1 * (pow(10, [CsBtCommon getUnitDecimalPoint])));
        long long lUnitPrice2 = (long long )(unitPrice2 * (pow(10, [CsBtCommon getUnitDecimalPoint])));
        Byte bytes[] = {0xA5, 0x01, 0x10, 0x12, (Byte)((productId >> 8) & 0xFF), (Byte)(productId & 0xFF), (Byte)((lUnitPrice >> 16) & 0xFF), (Byte)((lUnitPrice >> 8) & 0xFF), (Byte)(lUnitPrice & 0xFF), (Byte)((productId1 >> 8) & 0xFF), (Byte)(productId1 & 0xFF), (Byte)((lUnitPrice1 >> 16) & 0xFF), (Byte)((lUnitPrice1 >> 8) & 0xFF), (Byte)(lUnitPrice1 & 0xFF), (Byte)((productId2 >> 8) & 0xFF), (Byte)(productId2 & 0xFF), (Byte)((lUnitPrice2 >> 16) & 0xFF), (Byte)((lUnitPrice2 >> 8) & 0xFF), (Byte)(lUnitPrice2 & 0xFF), 0x00};
        self = [super initWithBytes:bytes length:20];
    }
    return self;
}

/**
 *  通知秤端要开始同步的帧
 */
+(instancetype)beginSyncFrame {
    return [[SyncUnitPriceFrame alloc] initWithProductId:0x0000 unitPrice:0 productId1:0 unitPrice1:0 productId2:0 unitPrice2:0];
}

/**
 *  通知秤端要结束同步的帧
 */
+(instancetype)endSyncFrame {
    return [[SyncUnitPriceFrame alloc] initWithProductId:0xFFFF unitPrice:0 productId1:0 unitPrice1:0 productId2:0 unitPrice2:0];
}

@end
