//
//  GoodsInfoModel.m
//  BusinessScale
//
//  Created by Alvin on 15/12/18.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "GoodsInfoModel.h"

@implementation GoodsInfoModel

- (instancetype)init
{
    if (self = [super init]) {
        _uid = [AccountTool account].ID;
        _mac = [ScaleTool scale].mac;
    }
    return self;
}

+ (NSString *)getTableName
{
    return [NSString stringWithFormat:@"GoodsList"];
}

+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"title",@"number"];
}

+(NSDictionary *)getTableMapping
{
    return nil;
}

+ (void)initialize
{
    [self setTableColumnName:@"isSychro" bindingPropertyName:@"isSychro"];
    [self setTableColumnName:@"uid" bindingPropertyName:@"uid"];
    [self setTableColumnName:@"mac" bindingPropertyName:@"mac"];
}


@end

@implementation GoodsTempList

- (instancetype)init
{
    if (self = [super init]) {
        _uid = [AccountTool account].ID;
        _mac = [ScaleTool scale].mac;
    }
    return self;
}

+ (NSString *)getTableName
{
    return [NSString stringWithFormat:@"GoodsTempList"];
}

+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"title",@"number"];
}

+(NSDictionary *)getTableMapping
{
    return nil;
}

+ (void)initialize
{
    [self setTableColumnName:@"isSychro" bindingPropertyName:@"isSychro"];
    [self setTableColumnName:@"uid" bindingPropertyName:@"uid"];
    [self setTableColumnName:@"mac" bindingPropertyName:@"mac"];
}

@end

