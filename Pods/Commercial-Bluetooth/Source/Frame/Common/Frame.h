//
//  Frame.h
//  对帧数据进行封装
//
//  Created by mac on 15-3-16.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FrameData;

@interface Frame : NSObject


@property(nonatomic) Byte startByte;
@property(nonatomic) Byte frameVer;
@property(nonatomic) Byte dataAreaLen;
@property(nonatomic) Byte commandByte;
@property(nonatomic) Byte checkByte;
// 数据正文
@property(nonatomic,strong) FrameData *dataArea;
@property(nonatomic,strong) NSData *frameFull;

/**
 *  初始化数据
 *
 *  @param data 数据
 *
 *  @return 初始化后的的帧对象
 */
-(id)initWithData:(NSData *)data;

/**
 *  根据字节数组进行创建帧数据
 *
 *  @param bytes  字节数组
 *  @param length 字节数组长度
 *
 *  @return 帧数据
 */
-(id)initWithBytes:(Byte *)bytes length:(NSUInteger)length;


/**
 *  获得数据的异或值----校验位,数据范围为版本号开始到正文结束
 *
 *  @return 数据的异或值
 */-(Byte)getDataXor;

/**
    打印数据
 */
-(void)printFrametoString;
@end
