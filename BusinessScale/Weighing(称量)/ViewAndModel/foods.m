
//
//  foods.m
//  BusinessScale
//
//  Created by Alvin on 15/12/29.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "foods.h"

@implementation foods

+ (NSString *)getTableName
{
    return @"foods";
}

+ (NSArray *)getPrimaryKeyUnionArray
{
    return @[@"name"];
}



@end
