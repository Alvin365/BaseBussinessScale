//
//  StraightFrameData.m
//  Commercial-Bluetooth
//
//  Created by ChipSea on 16/1/7.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "StraightFrameData.h"

@implementation StraightFrameData

-(id)initWithData:(NSData *)data {
    self = [super initWithData:data];
    if (self) {
        Byte *dataBytes = (Byte *)data.bytes;
        _isLock = dataBytes[1] == 0x01;
        _productId = ((dataBytes[2] & 0xFF) << 8)
                    | (dataBytes[3] & 0xFF);
        _weight = (long)(((dataBytes[4] & 0xFF) << 16)
                         | ((dataBytes[5] & 0xFF) << 8)
                         | (dataBytes[6] &0xFF)) / 1000.0;
        if (dataBytes[7] == 0x01) {
            _weight *= -1;
        }
        
    }
    return self;
}

@end
