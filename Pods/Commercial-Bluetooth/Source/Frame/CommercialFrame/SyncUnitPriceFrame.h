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
 *  根据产品代号、单价以及单位产生同步给硬件的帧数据
 *
 *  @param productId 产品代号
 *  @param unitPrice 单价
 *  @param unit      单位
 *
 *  @return 同步所有单价信息指令的帧数据
 */
-(instancetype)initWithProductId:(int)productId unitPrice:(float)unitPrice withUnit:(CsBtUnit)unit;

@end
