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
    p.urlString = [NSString stringWithFormat:@"%@account/login",userServerce];
    [p addParams:params];
    [p addParam:@"1" forKey:@"company_id"];
    [p addHeader:@"application/json" forKey:@"Content-Type"];
    return p;
}

+ (ALRequestParam *)registWithParams:(NSDictionary *)params
{
    ALRequestParam *p = [[ALRequestParam alloc]init];
    p.urlString = [NSString stringWithFormat:@"%@account/regist",userServerce];
    [p addParams:params];
    [p addParam:@"1" forKey:@"company_id"];
    [p addHeader:@"application/json" forKey:@"Content-Type"];
    return p;
}

+ (ALRequestParam *)getVeryCodeWithParams:(NSDictionary *)params
{
    ALRequestParam *p = [[ALRequestParam alloc]init];
    p.urlString = [NSString stringWithFormat:@"%@vericode",userServerce];
    [p addParams:params];
    [p addHeader:[AccountTool account].token forKey:@"cs-token"];
    [p addParam:@"1" forKey:@"company_id"];
    [p addHeader:@"application/json" forKey:@"Content-Type"];
    return p;
}

+ (ALRequestParam *)forgetPasswordWithParams:(NSDictionary *)params
{
    ALRequestParam *p = [[ALRequestParam alloc]init];
    p.urlString = [NSString stringWithFormat:@"%@pwdreset",userServerce];
    [p addParams:params];
    [p addHeader:[AccountTool account].token forKey:@"cs-token"];
    [p addParam:@"1" forKey:@"company_id"];
    [p addHeader:@"application/json" forKey:@"Content-Type"];
    return p;
}

+ (ALRequestParam *)updatePassWordWithParams:(NSDictionary *)params
{
    ALRequestParam *p = [[ALRequestParam alloc]init];
    p.urlString = [NSString stringWithFormat:@"%@account/pwd/update",userServerce];
    [p addParams:params];
    [p addHeader:[AccountTool account].token forKey:@"cs-token"];
//    [p addParam:@"1" forKey:@"company_id"];
    [p addHeader:@"application/json" forKey:@"Content-Type"];
    return p;
}

@end
