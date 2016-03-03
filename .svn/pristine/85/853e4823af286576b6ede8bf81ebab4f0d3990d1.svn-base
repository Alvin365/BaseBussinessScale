//
//  SaleModel.m
//  BusinessScale
//
//  Created by Alvin on 15/12/29.
//  Copyright © 2015年 Alvin. All rights reserved.
//
#import "SaleModel.h"

@implementation SaleItem

- (instancetype)init
{
    if (self = [super init]) {
//        _uid = [AccountTool account].ID;
        _mac = [ScaleTool scale].mac;
    }
    return self;
}


+ (NSString *)getTableName
{
    return [NSString stringWithFormat:@"saleItem%@",[AccountTool account].ID];
}

+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"ts"];
    return nil;
}

+ (void)initialize
{
    // remove unwant property
//    [self removePropertyWithColumnName:@"discount"];
    
    [self setTableColumnName:@"total_price" bindingPropertyName:@"total_price"];
    [self setTableColumnName:@"paid_price" bindingPropertyName:@"paid_price"];
    [self setTableColumnName:@"uid" bindingPropertyName:@"uid"];
    [self setTableColumnName:@"mac" bindingPropertyName:@"mac"];
}

@end

@implementation SaleTable

- (instancetype)init
{
    if (self = [super init]) {
//        _uid = [AccountTool account].ID;
        _mac = [ScaleTool scale].mac;
    }
    return self;
}


+ (NSString *)getTableName
{
    return [NSString stringWithFormat:@"SaleTable%@",[AccountTool account].ID];
}

+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"ts"];
}

+ (void)initialize
{
    // remove unwant property
    [self removePropertyWithColumnName:@"isUpLoad"];
    [self setTableColumnName:@"uid" bindingPropertyName:@"uid"];
    [self setTableColumnName:@"mac" bindingPropertyName:@"mac"];
    [self setTableColumnName:@"po_uuid" bindingPropertyName:@"po_uuid"];
}

@end
