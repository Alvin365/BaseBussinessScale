//
//  SUPRepFrame.h
//  Commercial-Bluetooth
//  同步单价的应答指令的帧数据
//
//  Created by ChipSea on 16/1/6.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "Frame.h"

@interface SUPRespFrame : Frame

@property (assign, nonatomic) int productId;
@property (assign, nonatomic) BOOL success;

@end
