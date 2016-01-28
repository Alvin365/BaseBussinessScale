//
//  TransactionDataRespFrame.h
//  Commercial-Bluetooth
//
//  Created by ChipSea on 16/1/26.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "Frame.h"

/**
 *  同步历史交易记录的应答
 *  蓝牙端是一条一条的发送给App，其中状态一般都为YES的
 */
@interface TransactionDataSyncRespFrame : Frame

-(instancetype)initWithProductId:(int)productId status:(BOOL)success;

@end
