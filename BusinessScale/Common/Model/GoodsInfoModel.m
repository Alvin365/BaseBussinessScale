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

@end

@implementation GoodsTemp

+ (NSString *)getTableName
{
    return [NSString stringWithFormat:@"GoodsTemp"];
}

@end
