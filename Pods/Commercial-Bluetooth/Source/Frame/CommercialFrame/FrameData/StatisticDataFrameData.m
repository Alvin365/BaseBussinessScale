//
//  StatisticDataFrameData.m
//  Commercial-Bluetooth
//  对上传的统计帧的数据部分进行解析
//
//  Created by ChipSea on 16/1/7.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "StatisticDataFrameData.h"

@implementation StatisticDataFrameData

-(id)initWithData:(NSData *)data {
    self = [super initWithData:data];
    if (self) {
        Byte *dataBytes = (Byte *)data.bytes;
        _frameNum = ((dataBytes[1] & 0xFF) << 8) | (dataBytes[2] & 0xFF);
        _totoalFrame = ((dataBytes[3] & 0xFF) << 8) | (dataBytes[4] & 0xFF);
        int year = dataBytes[5];
        int month = dataBytes[6];
        int day = dataBytes[7];
        int hours = dataBytes[8];
        int mins = dataBytes[9];
        int secs = dataBytes[10];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        if (year > 100) {
            [formatter setDateFormat:@"yyyMMddHHmmss"];
        } else {
            [formatter setDateFormat:@"yyMMddHHmmss"];
        }
        NSString *dateString = [NSString stringWithFormat:@"%d%@%@%@%@%@", year, [self getNumString:month], [self getNumString:day], [self getNumString:hours], [self getNumString:mins], [self getNumString:secs]];
        _weightDate = [formatter dateFromString:dateString];
        _productId = ((dataBytes[11] & 0xFF) << 8) | (dataBytes[12] & 0xFF);
        _weight = (long)(((dataBytes[13] & 0xFF) << 16) |((dataBytes[14] & 0xFF) << 8) | (dataBytes[15] & 0xFF)) / 1000.0;
        
    }
    return self;
}

-(NSString *) getNumString:(int)num {
    return num >= 10 ? [NSString stringWithFormat:@"%d", num] : [NSString stringWithFormat:@"0%d", num];
}

@end
