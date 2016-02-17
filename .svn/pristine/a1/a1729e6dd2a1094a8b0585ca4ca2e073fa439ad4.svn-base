//
//  StatisticDataReqFrame.m
//  Commercial-Bluetooth
//  请求交易记录数据的帧数据
//
//  Created by ChipSea on 16/1/7.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "TransactionDataReqFrame.h"

@implementation TransactionDataReqFrame

-(instancetype)init {
    self = [super init];
    if (self) {
        Byte bytes[] = {0xA5, 0x01, 0x01, 0x33, 0x00};
        self = [super initWithBytes:bytes length:5];
    }
    return self;
}

@end
