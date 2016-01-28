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
        _xorValue = frameByte[4];
        _success = frameByte[5] == 0x01 ? YES : NO;
    }
    return self;
}

@end
