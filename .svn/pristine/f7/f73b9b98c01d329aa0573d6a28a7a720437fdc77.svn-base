//
//  ScaleTool.m
//  BusinessScale
//
//  Created by Alvin on 16/1/12.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "ScaleTool.h"

#define ScaleFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"scale.data"]

@implementation ScaleModel

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.deviceType = [decoder decodeObjectForKey:@"deviceType"];
        self.deviceProductId = [[decoder decodeObjectForKey:@"deviceProductId"] intValue];
        self.mac = [decoder decodeObjectForKey:@"mac"];
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 *  在这个方法中写清楚：要存储哪些对象的哪些属性，以及怎样存储属性
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:@(self.deviceProductId) forKey:@"deviceProductId"];
    [encoder encodeObject:self.deviceType forKey:@"deviceType"];
    [encoder encodeObject:self.mac forKey:@"mac"];
}

@end

@implementation ScaleTool

+ (void)saveScale:(ScaleModel *)model
{
    [NSKeyedArchiver archiveRootObject:model toFile:ScaleFilepath];
}

+ (ScaleModel *)scale
{
    ScaleModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:ScaleFilepath];
    if (!model) {
        model = [[ScaleModel alloc]init];
    }
    return model;
}

@end
