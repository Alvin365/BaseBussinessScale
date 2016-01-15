//
//  BroadcastFrameData.h
//  Commercial-Bluetooth
//
//  Created by ChipSea on 16/1/7.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "FrameData.h"

@interface BroadcastFrameData : FrameData

@property (assign, nonatomic) int deviceProductId;
@property (assign, nonatomic) float weight;
@property (assign, nonatomic) Byte deviceType;

@end
