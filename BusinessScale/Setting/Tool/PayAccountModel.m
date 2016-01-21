//
//  PayAccountModel.m
//  BusinessScale
//
//  Created by Alvin on 16/1/21.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "PayAccountModel.h"

@implementation PayAccountModel

+ (NSString *)getTableName
{
    return [NSString stringWithFormat:@"payAccountTable%@",[AccountTool account].ID];
}

+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"third_uuid"];
}

@end
