//
//  StatisticDataFrame.m
//  Commercial-Bluetooth
//
//  Created by ChipSea on 16/1/7.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "StatisticDataFrame.h"
#import "StatisticDataFrameData.h"

@implementation StatisticDataFrame

-(id)initWithData:(NSData *)data {
    self = [super initWithData:data];
    if (self) {
        Byte *frameByte = (Byte *)self.frameFull.bytes;
        int count = frameByte[2];
        NSRange range = NSMakeRange(3, count);
        NSData * dataArea = [data subdataWithRange:range];
        self.dataArea = [[StatisticDataFrameData alloc] initWithData:dataArea];
        _data = [[StatisticData alloc] init];
        StatisticDataFrameData *frameData = (StatisticDataFrameData *)self.dataArea;
        _data.frameNum = frameData.frameNum;
        _data.totalFrame = frameData.totoalFrame;
        _data.weightDate = frameData.weightDate;
        _data.productId = frameData.productId;
        _data.weight = frameData.weight;
    }
    return self;
}

-(StatisticData *)getData {
    return _data;
}

@end
