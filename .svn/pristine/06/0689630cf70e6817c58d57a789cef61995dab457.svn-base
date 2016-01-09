//
//  SaleModel.m
//  BusinessScale
//
//  Created by Alvin on 15/12/29.
//  Copyright © 2015年 Alvin. All rights reserved.
//
#import "SaleModel.h"

@implementation SaleItem

+ (NSString *)getTableName
{
    return @"saleItem";
}

//+ (NSArray *)getPrimaryKeyUnionArray
//{
//    return @[@"title"];
//}

+ (void)initialize
{
    // remove unwant property
    [self removePropertyWithColumnName:@"error"];
}

@end

@implementation SaleTable

+ (NSString *)getTableName
{
    return @"saleTable";
}

+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"ts"];
}

+ (void)initialize
{
    // remove unwant property
    [self removePropertyWithColumnName:@"error"];
}

@end
