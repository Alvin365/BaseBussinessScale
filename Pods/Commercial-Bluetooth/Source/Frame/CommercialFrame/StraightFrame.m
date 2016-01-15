//
//  StraightFrame.m
//  Commercial-Bluetooth
//
//  Created by ChipSea on 16/1/7.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "StraightFrame.h"
#import "StraightFrameData.h"

@implementation StraightFrame

-(id)initWithData:(NSData *)data {
    self = [super initWithData:data];
    if (self) {
        Byte *frameByte = (Byte *)self.frameFull.bytes;
        int count = frameByte[2];
        NSRange range = NSMakeRange(3, count);
        NSData * dataArea = [data subdataWithRange:range];
        self.dataArea = [[StraightFrameData alloc] initWithData:dataArea];
        _data = [[StraightData alloc] init];
        StraightFrameData *frameData = (StraightFrameData *)self.dataArea;
        _data.productId = frameData.productId;
        _data.isLock = frameData.isLock;
        _data.weight = frameData.weight;
    }
    return self;
}

-(StraightData *)getData {
    return _data;
}

@end
