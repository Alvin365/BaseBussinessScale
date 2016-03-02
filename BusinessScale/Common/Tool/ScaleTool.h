//
//  ScaleTool.h
//  BusinessScale
//
//  Created by Alvin on 16/1/12.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScaleModel: BaseModel<NSCoding>

@property (assign, nonatomic) NSString *deviceType;
@property (assign, nonatomic) int deviceProductId;
/**
 * 重量小数点位数
 */
@property (assign, nonatomic) int wDecimalPoint;
/**
 * 单价小数点位数
 */
@property (assign, nonatomic) int uDecimalPoint;
/**
 * 是否是app收款
 */
@property (nonatomic, assign) BOOL appReceipt;
@property (nonatomic, assign) float weight;
@property (retain, nonatomic) NSString *mac;

@end

@interface ScaleTool : NSObject

+ (void)saveScale:(ScaleModel *)model;

+ (ScaleModel *)scale;

@end
