//
//  SignFrame.h
//  Commercial-Bluetooth
//
//  Created by ChipSea on 16/1/24.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "Frame.h"

@interface SignFrame : Frame

/**
 *  根据随机数以及pin值产生握手机制的签名
 *
 *  @param randomNum 秤端获得的随机数
 *  @param pin       pin值
 *
 *  @return 同步跟秤端的帧数据
 */
-(id)initWithRandomNum:(NSString *)randomNum pin:(NSString *)pin;

@end
