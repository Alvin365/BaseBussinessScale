//
//  GoodsInfoModel.m
//  BusinessScale
//
//  Created by Alvin on 15/12/18.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "GoodsInfoModel.h"

@implementation GoodsInfoModel

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

+(void)columnAttributeWithProperty:(LKDBProperty *)property
{
    if([property.propertyName isEqualToString:@"uid"])
    {
        property.defaultValue = [AccountTool account].ID;
    }
    else if([property.propertyName isEqualToString:@"mac"])
    {
        property.defaultValue = [ScaleTool scale].mac;
    }
}

@end

@implementation GoodsTempList

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

+(void)columnAttributeWithProperty:(LKDBProperty *)property
{
    if([property.sqlColumnName isEqualToString:@"uid"])
    {
        property.defaultValue = [AccountTool account].ID;
    }
    else if([property.sqlColumnName isEqualToString:@"mac"])
    {
        property.defaultValue = [ScaleTool scale].mac;
    }
}

@end

