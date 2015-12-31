//
//  LoginHttpTool.m
//  BusinessScale
//
//  Created by Alvin on 15/12/28.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "LoginHttpTool.h"

@implementation LoginHttpTool

+ (ALRequestParam *)loginWithParams:(NSDictionary *)params
{
    ALRequestParam *p = [[ALRequestParam alloc]init];
    p.urlString = [NSString stringWithFormat:@"%@account/login",TestServerce];
    [p addParam:@"18682042276" forKey:@"uid"];
    [p addParam:@"123456" forKey:@"password"];
    [p addParam:@"1" forKey:@"company_id"];
    [p addHeader:@"application/json" forKey:@"Content-Type"];
    return p;
}

@end
