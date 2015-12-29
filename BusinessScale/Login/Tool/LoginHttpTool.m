//
//  LoginHttpTool.m
//  BusinessScale
//
//  Created by Alvin on 15/12/28.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "LoginHttpTool.h"

@implementation LoginHttpTool

+ (void)loginWithParams:(NSDictionary *)params completedBlock:(void (^)(id))completedBlock
{
    [self post:[NSString stringWithFormat:@"%@account/login",TestServerce] params:params completedBlock:completedBlock];
}

@end
