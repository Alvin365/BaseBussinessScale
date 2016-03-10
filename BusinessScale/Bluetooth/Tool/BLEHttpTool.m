//
//  BLEHttpTool.m
//  BusinessScale
//
//  Created by Alvin on 16/2/26.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "BLEHttpTool.h"

@implementation BLEHttpTool

+ (ALRequestParam *)boundScale:(BroadcastData *)data
{
    ALRequestParam *param = [[ALRequestParam alloc]init];
    [param addParam:@(data.deviceProductId) forKey:@"product_id"];
    [param addParam:[data.mac uppercaseString] forKey:@"scale_mac"];
    [param addParam:@(data.wDecimalPoint) forKey:@"weight_digit"];
    [param addParam:@(data.uDecimalPoint) forKey:@"price_digit"];
    param.method = ALHttpPut;
    param.urlString = [NSString stringWithFormat:@"%@scale",userServerce];
    return param;
}

+ (ALRequestParam *)deleteScale;
{
    ALRequestParam *p = [[ALRequestParam alloc]init];
    p.method = ALHttpDelete;
    p.urlString = [NSString stringWithFormat:@"%@scale",userServerce];
    return p;
}

+ (ALRequestParam *)getScaleInfo;
{
    ALRequestParam *p = [[ALRequestParam alloc]init];
    p.method = ALHttpGet;
    p.urlString = [NSString stringWithFormat:@"%@scale",userServerce];
    return p;
}


@end
