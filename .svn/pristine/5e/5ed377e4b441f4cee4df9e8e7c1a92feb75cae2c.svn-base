//
//  StatisticDataFrame.m
//  Commercial-Bluetooth
//
//  Created by ChipSea on 16/1/7.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "TransactionDataFrame.h"
#import "TransactionDataFrameData.h"

@implementation TransactionDataFrame

-(id)initWithData:(NSData *)data {
    self = [super initWithData:data];
    if (self) {
        Byte *frameByte = (Byte *)self.frameFull.bytes;
        int count = frameByte[2];
        NSRange range = NSMakeRange(3, count);
        NSData * dataArea = [data subdataWithRange:range];
        self.dataArea = [[TransactionDataFrameData alloc] initWithData:dataArea];
        _data = [[TransactionData alloc] init];
        TransactionDataFrameData *frameData = (TransactionDataFrameData *)self.dataArea;
        _data.productId = frameData.productId;
        _data.weight = frameData.weight;
        _data.seqNum = frameData.seqNum;
        _data.unitPrice = frameData.unitPrice;
        _data.totalPrice = frameData.totalPrice;
        _data.weightDate = frameData.weightDate;
    }
    return self;
}

-(TransactionData *)getData {
    return _data;
}

@end
