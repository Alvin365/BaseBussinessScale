//
//  StatisticData.h
//  Commercial-Bluetooth
//  提供出去的统计数据
//
//  Created by ChipSea on 16/1/7.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatisticData : NSObject

@property (assign, nonatomic) int frameNum;
@property (assign, nonatomic) int totalFrame;
@property (retain, nonatomic) NSDate *weightDate;
@property (assign, nonatomic) int productId;
@property (assign, nonatomic) float weight;

@end
