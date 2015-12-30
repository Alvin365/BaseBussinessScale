//
//  BaseModel.m
//  BusinessScale
//
//  Created by Alvin on 15/12/15.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+ (LKDBHelper *)getUsingLKDBHelper
{
    // 重载选择 使用的LKDBHelper
    static LKDBHelper* db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *daPath = [ALDocuMentPath stringByAppendingPathComponent:@"dataBase.db"];
        db = [[LKDBHelper alloc]initWithDBPath:daPath];
    });
    return db;
}

@end
