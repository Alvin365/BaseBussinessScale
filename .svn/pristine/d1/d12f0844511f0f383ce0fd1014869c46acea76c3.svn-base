//
//  ReceiptsTDRespFrame.h
//  Commercial-Bluetooth
//
//  Created by ChipSea on 16/1/26.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "Frame.h"

/**
 *  在线收款情况下接收到秤端数据的应答帧数据
 *  目前应答分为两种，一种为接收到秤端数据的单条数据的应答，一种为付款的应答，而当时为付款的应答则产品编号为0x0000
 *  对于第一种的状态字节分为两种，一种是0x00表示接收失败, 一种是0x01表示接收成功
 *  对于第二种的状态字节分为两种,一种是0x02表示支付失败,一种0x03表示支付成功，
 */
@interface ReceiptsTDRespFrame : Frame

-(instancetype)initWithProductId:(int)productId status:(Byte)status;

@end
