//
//  StatisticDataFrame.h
//  Commercial-Bluetooth
//  上传的统计数据的帧数据
//
//  Created by ChipSea on 16/1/7.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "Frame.h"
#import "TransactionData.h"

/**
 *  针对交易记录的帧数据的解析
 *  当出现产品编号为0xFFFF（即65535的情况的话表示之前的交易为同一单中的交易）
 *  并且在0xFFFF中的价格为之前单中的折扣价格
 *  如果出现产品编号为0x0000的话表示没有离线交易数据了
 */
@interface TransactionDataFrame : Frame

@property (retain, nonatomic) TransactionData *data;

@end
