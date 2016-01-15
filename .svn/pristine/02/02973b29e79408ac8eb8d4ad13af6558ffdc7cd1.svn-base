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
@property (retain, nonatomic) NSString *mac;

@end

@interface ScaleTool : NSObject

+ (void)saveScale:(ScaleModel *)model;

+ (ScaleModel *)scale;

@end
