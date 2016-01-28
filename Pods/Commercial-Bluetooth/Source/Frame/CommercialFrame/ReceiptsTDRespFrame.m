//
//  ReceiptsTDRespFrame.m
//  Commercial-Bluetooth
//
//  Created by ChipSea on 16/1/26.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "ReceiptsTDRespFrame.h"

@implementation ReceiptsTDRespFrame

-(instancetype)initWithProductId:(int)productId status:(Byte)status {
    self = [super init];
    if (self) {
        if (productId == 0x0000 && (status != 0x02 && status != 0x03)) {
            NSLog(@"状态字与产品编号不对应");
            return nil;
        }
        if (productId != 0x0000 && (status != 0x00 && status != 0x01)) {
            NSLog(@"状态字与产品编号不对应");
            return nil;
        }
        Byte bytes[] = {0xA5, 0x01, 0x04, 0x23, (Byte)((productId >> 8) & 0xFF), (Byte)(productId & 0xFF), status, 0x00};
        self = [super initWithBytes:bytes length:8];
    }
    return self;
}

@end
