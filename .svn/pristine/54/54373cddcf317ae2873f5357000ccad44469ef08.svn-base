//
//  SyncUnitPriceFrame.h
//  Commercial-Bluetooth
//
//  同步所有单价信息指令的帧数据的封装
//
//  Created by ChipSea on 16/1/6.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "Frame.h"
#import "CsBtCommon.h"

@interface SyncUnitPriceFrame : Frame

/**
 *  通知秤端要开始同步的帧
 */
+(instancetype)beginSyncFrame;

/**
 *  通知秤端要结束同步的帧
 */
+(instancetype)endSyncFrame;

/**
 *  根据产品代号和单价产生同步给硬件的帧数据
 *  开始下传前，首先要先下传0x0000表示开始下传单价
 *  结束之前要下传一个0xFFFF表示下传单价结束
 *  如果不满3个的话，其他的产品代号和单价都设置成0即可
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

-(instancetype)initWithProductId:(int)productId unitPrice:(float)unitPrice productId1:(int)productId1 unitPrice1:(float)unitPrice1 productId2:(int)productId2 unitPrice2:(float)unitPrice2;

@end
