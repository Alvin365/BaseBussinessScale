//
//  StatisticDataFrameData.m
//  Commercial-Bluetooth
//  对上传的交易记录帧的数据部分进行解析
//
//  Created by ChipSea on 16/1/7.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "TransactionDataFrameData.h"
#import "CsBtCommon.h"

@implementation TransactionDataFrameData

-(id)initWithData:(NSData *)data {
    self = [super initWithData:data];
    if (self) {
        Byte *dataBytes = (Byte *)data.bytes;
        _productId = ((dataBytes[1] & 0xFF) << 8) | (dataBytes[2] & 0xFF);
        if ((dataBytes[9] >> 7) == 0x0) {
            _weight = (long)(((dataBytes[3] & 0xFF) << 16) |((dataBytes[4] & 0xFF) << 8) | (dataBytes[5] & 0xFF)) / pow(10, [CsBtCommon getWeightDecimalPoint]);
        } else {
            _weight = (long)(((dataBytes[3] & 0xFF) << 16) |((dataBytes[4] & 0xFF) << 8) | (dataBytes[5] & 0xFF));
        }
        _seqNum = (int)(dataBytes[6] & 0xFC);
        _unitPrice = (long)(((dataBytes[6] & 0x03) << 16) | ((dataBytes[7] & 0xFF) << 8) | (dataBytes[8] & 0xFF)) / pow(10, [CsBtCommon getUnitDecimalPoint]);
        _totalPrice = (long)(((dataBytes[9] & 0x7F) << 16) | ((dataBytes[10] & 0xFF) << 8) | (dataBytes[11] & 0xFF)) / pow(10, [CsBtCommon getUnitDecimalPoint]);
        long long timestamp = (long long)(((dataBytes[12] & 0xFF) << 24) | ((dataBytes[13] & 0xFF) << 16) | ((dataBytes[14] & 0xFF) << 8) | (dataBytes[15] & 0xFF));
        _weightDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    }
    return self;
}

-(NSString *) getNumString:(int)num {
    return num >= 10 ? [NSString stringWithFormat:@"%d", num] : [NSString stringWithFormat:@"0%d", num];
}

@end
