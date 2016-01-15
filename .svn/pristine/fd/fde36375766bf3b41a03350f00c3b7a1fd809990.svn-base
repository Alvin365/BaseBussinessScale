//
//  PayModelTool.m
//  BusinessScale
//
//  Created by Alvin on 16/1/14.
//  Copyright © 2016年 Alvin. All rights reserved.
//
#define payAccountList [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"payAccountList.data"]

#import "PayAccountTool.h"

@implementation PayAccountModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.aid = [[aDecoder decodeObjectForKey:@"aid"] intValue];
        self.id = [[aDecoder decodeObjectForKey:@"id"] integerValue];
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.realname = [aDecoder decodeObjectForKey:@"realname"];
        self.third_id = [aDecoder decodeObjectForKey:@"third_id"];
        self.third_type = [aDecoder decodeObjectForKey:@"third_type"];
        self.third_uuid = [aDecoder decodeObjectForKey:@"third_uuid"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:@(self.aid) forKey:@"aid"];
    [encoder encodeObject:@(self.id) forKey:@"id"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    [encoder encodeObject:self.realname forKey:@"realname"];
    [encoder encodeObject:self.third_id forKey:@"third_id"];
    [encoder encodeObject:self.third_type forKey:@"third_type"];
    [encoder encodeObject:self.third_uuid forKey:@"third_uuid"];
}

@end

@implementation PayAccountTool

+ (void)savePayAccountList:(NSArray *)array
{
    [NSKeyedArchiver archiveRootObject:array toFile:payAccountList];
}

+ (NSArray *)list
{
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithFile:payAccountList];
    return array;
}

+ (PayAccountModel *)alipayAccount
{
    PayAccountModel *des = nil;
    for (PayAccountModel *model in [self list]) {
        if ([model.third_type isEqualToString:@"alipay"]) {
            des = model;
        }
    }
    return des;
}

+ (PayAccountModel *)weixinAccount
{
    PayAccountModel *des = nil;
    for (PayAccountModel *model in [self list]) {
        if ([model.third_type isEqualToString:@"weixin"]) {
            des = model;
        }
    }
    return des;
}

@end
