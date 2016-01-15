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
    return [NSString stringWithFormat:@"GoodsList%@",[AccountTool account].ID];
}

+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"title"];
}

+(NSDictionary *)getTableMapping
{
    return nil;
}

+ (void)initialize
{
    [self setTableColumnName:@"isSychro" bindingPropertyName:@"isSychro"];
}

@end
