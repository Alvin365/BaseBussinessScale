//
//  SyncTimeFrame.h
//  Commercial-Bluetooth
//  同步时间到秤端的帧数据
//
//  Created by ChipSea on 16/1/6.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "Frame.h"

@interface SyncTimeFrame : Frame

/**
 *  根据时间产生帧数据
 *
 *  @return 同步时间到秤端的帧数据
 */
-(id)init;

@end
