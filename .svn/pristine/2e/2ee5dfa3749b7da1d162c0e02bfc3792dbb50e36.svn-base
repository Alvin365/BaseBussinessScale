//
//  SynTimeRespFrame.m
//  Commercial-Bluetooth
//
//  Created by ChipSea on 16/1/7.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "SyncTimeRespFrame.h"

@implementation SyncTimeRespFrame

-(id)initWithData:(NSData *)data {
    self = [super initWithData:data];
    if (self) {
        Byte *frameByte = (Byte *)self.frameFull.bytes;
        _success = frameByte[4] == 0x00 ? YES : NO;
    }
    return self;
}

@end
