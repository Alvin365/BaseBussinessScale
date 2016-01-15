//
//  StatisticDataFrame.h
//  Commercial-Bluetooth
//  上传的统计数据的帧数据
//
//  Created by ChipSea on 16/1/7.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "Frame.h"
#import "StatisticData.h"

@interface StatisticDataFrame : Frame

@property (retain, nonatomic) StatisticData *data;

@end
