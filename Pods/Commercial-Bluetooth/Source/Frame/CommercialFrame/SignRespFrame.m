//
//  SignRespFrame.m
//  Commercial-Bluetooth
//
//  Created by ChipSea on 16/1/24.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "SignRespFrame.h"

@implementation SignRespFrame

-(id)initWithData:(NSData *)data {
    self = [super initWithData:data];
    if (self) {
        Byte *dataBytes = (Byte *)data.bytes;
        _success = dataBytes[4] == 0x01 ? YES : NO;
    }
    return self;
}

@end
