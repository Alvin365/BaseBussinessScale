//
//  ReceivedTDRespFrame.m
//  Commercial-Bluetooth
//
//  Created by ChipSea on 16/1/26.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "ReceivedTDRespFrame.h"

@implementation ReceivedTDRespFrame

-(instancetype)initWithProductId:(int)productId status:(BOOL)success {
    self = [super init];
    if (self) {
        Byte bytes[] = {0xA5, 0x01, 0x04, 0x2C, (Byte)((productId >> 8) & 0xFF), (Byte)(productId & 0xFF), (Byte)(success ? 0x01 : 0x00), 0x00};
        self = [super initWithBytes:bytes length:8];
    }
    return self;
}

@end
