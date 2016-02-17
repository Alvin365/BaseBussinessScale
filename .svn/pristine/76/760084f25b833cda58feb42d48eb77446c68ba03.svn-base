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
        _deviceProductId = (int) ((dataBytes[4] & 0xFF)
                            | ((dataBytes[3] & 0xFF)<<8)
                            | ((dataBytes[2] & 0xFF)<<16)
                            | ((dataBytes[1] & 0xFF)<<24));
        _wDecimalPoint = (int)(dataBytes[5] & 0xFF);
        _uDecimalPoint = (int)(dataBytes[6] & 0xFF);
        _appReceipt = (dataBytes[7] == 0) ? NO : YES;
        _weight = (long)(((dataBytes[8] & 0x7F) << 16)
                         | ((dataBytes[9] & 0xFF) << 8)
                         | (dataBytes[10] &0xFF)) / pow(10, _wDecimalPoint);
        if ((dataBytes[8] >> 3) == 0x01) {
            _weight *= -1;
        }
        
    }
    return self;
}

@end
