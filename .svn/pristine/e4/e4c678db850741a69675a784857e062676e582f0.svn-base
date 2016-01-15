//
//  BroadcastFrameData.m
//  Commercial-Bluetooth
//
//  Created by ChipSea on 16/1/7.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "BroadcastFrameData.h"

@implementation BroadcastFrameData

-(id)initWithData:(NSData *)data {
    self = [super initWithData:data];
    if (self) {
        Byte *dataBytes = (Byte *)data.bytes;
        _deviceProductId = (int) ((dataBytes[5] & 0xFF)
                            | ((dataBytes[4] & 0xFF)<<8)
                            | ((dataBytes[3] & 0xFF)<<16)
                            | ((dataBytes[2] & 0xFF)<<24));
        _weight = (long)(((dataBytes[6] & 0xFF) << 16)
                         | ((dataBytes[7] & 0xFF) << 8)
                         | (dataBytes[8] &0xFF)) / 1000.0;
        if (dataBytes[9] == 0x01) {
            _weight *= -1;
        }
        _deviceType = dataBytes[1];
        
    }
    return self;
}

@end
