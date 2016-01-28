//
//  StatisticData.h
//  Commercial-Bluetooth
//  提供出去的交易记录数据
//
//  Created by ChipSea on 16/1/7.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransactionData : NSObject

@property (assign, nonatomic) int productId; // 编号
@property (assign, nonatomic) float weight; // 重量
@property (assign, nonatomic) int seqNum;
@property (assign, nonatomic) float unitPrice;  // 单价
@property (assign, nonatomic) float totalPrice; // 总价
@property (retain, nonatomic) NSDate *weightDate; // 时间戳

@end
