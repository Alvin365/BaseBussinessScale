//
//  SUPRepFrame.m
//  Commercial-Bluetooth
//
//  Created by ChipSea on 16/1/6.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "SUPRespFrame.h"

@implementation SUPRespFrame

-(id)initWithData:(NSData *)data {
    self = [super initWithData:data];
    if (self) {
        Byte *frameByte = (Byte *)self.frameFull.bytes;
        _productId = (int)(((frameByte[4] & 0xFF) << 8) | (frameByte[5] & 0xFF));
        _success = frameByte[6] == 0x00 ? YES : NO;
    }
    return self;
}

@end
