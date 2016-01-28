//
//  ReceivedTDRespFrame.h
//  Commercial-Bluetooth
//
//  Created by ChipSea on 16/1/26.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "Frame.h"

/**
 *  App收款的的情况
 *  即App负责接收秤端的称重数据，之后通过这些称重数据在App端进行结算
 *  结算金额由App来处理
 */
@interface ReceivedTDRespFrame : Frame

-(instancetype)initWithProductId:(int)productId status:(BOOL)success;

@end
