//
//  BroadcastFrame.h
//  Commercial-Bluetooth
//
//  Created by ChipSea on 16/1/7.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "Frame.h"
#import "BroadcastData.h"

@interface BroadcastFrame : Frame

@property (retain, nonatomic) BroadcastData *data;


@end
