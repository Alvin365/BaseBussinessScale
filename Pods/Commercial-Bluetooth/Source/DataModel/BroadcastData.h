//
//  BroadcastData.h
//  Commercial-Bluetooth
//
//  Created by ChipSea on 16/1/7.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BroadcastData : NSObject

@property (assign, nonatomic) int deviceProductId;
/// 重量小数点位数
@property (assign, nonatomic) int wDecimalPoint;
/// 单价小数点位数
@property (assign, nonatomic) int uDecimalPoint;
/// 是否是App收款
@property (assign, nonatomic) BOOL appReceipt;
@property (assign, nonatomic) float weight;
@property (retain, nonatomic) NSString *mac;

@end
