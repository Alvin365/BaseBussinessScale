//
//  ResetDataFrame.m
//  Commercial-Bluetooth
//
//  Created by ChipSea on 16/2/19.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "ResetDataReqFrame.h"

@implementation ResetDataReqFrame

- (instancetype)init
{
    self = [super init];
    if (self) {
        Byte bytes[] = {0xA5, 0x01, 0x01, 0x35, 0x00};
        self = [super initWithBytes:bytes length:5];
    }
    return self;
}

@end
