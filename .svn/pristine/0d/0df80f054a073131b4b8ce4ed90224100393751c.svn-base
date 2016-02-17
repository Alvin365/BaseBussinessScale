//
//  BroadcastFrame.m
//  Commercial-Bluetooth
//
//  Created by ChipSea on 16/1/7.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "BroadcastFrame.h"
#import "BroadcastFrameData.h"

@implementation BroadcastFrame

-(id)initWithData:(NSData *)data {
    self = [super initWithData:data];
    if (self) {
        Byte *frameByte = (Byte *)self.frameFull.bytes;
        int count = frameByte[2];
        NSRange range = NSMakeRange(3, count);
        NSData * dataArea = [data subdataWithRange:range];
        self.dataArea = [[BroadcastFrameData alloc] initWithData:dataArea];
        _data = [[BroadcastData alloc] init];
        BroadcastFrameData *frameData = (BroadcastFrameData *)self.dataArea;
        _data.deviceProductId = frameData.deviceProductId;
        _data.wDecimalPoint = frameData.wDecimalPoint;
        _data.uDecimalPoint = frameData.uDecimalPoint;
        _data.appReceipt = frameData.appReceipt;
        _data.weight = frameData.weight;
    }
    return self;
}

-(BroadcastData *)getData {
    return _data;
}

@end
