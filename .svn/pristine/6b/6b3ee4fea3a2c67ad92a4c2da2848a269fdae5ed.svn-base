//
//  WeightHttpTool.m
//  BusinessScale
//
//  Created by Alvin on 15/12/28.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "WeightHttpTool.h"

@implementation WeightHttpTool

+ (ALRequestParam *)uploadSaleRecord:(NSDictionary *)params
{
    ALRequestParam *p = [[ALRequestParam alloc]init];
    [p addHeader:[AccountTool account].token forKey:@"cs-token"];
    [p addHeader:@"application/json" forKey:@"Content-Type"];
    p.method = ALHttpPut;
    for (NSString *key in params.allKeys) {
        [p addParam:params[key] forKey:key];
    }
    [p setHttpBody:params];
    p.urlString = [NSString stringWithFormat:@"%@po",TestServerce];
    return p;
}

+ (ALRequestParam *)batchUploadSaleRecords:(NSDictionary *)params
{
    ALRequestParam *p = [[ALRequestParam alloc]init];
    [p addHeader:[AccountTool account].token forKey:@"cs-token"];
    [p addHeader:@"text/plain" forKey:@"Content-Type"];
    p.method = ALHttpPut;
//    for (NSString *key in params.allKeys) {
//        [p addParam:params[key] forKey:key];
//    }
    [p setHttpBody:params];
    p.urlString = [NSString stringWithFormat:@"%@pobatch",TestServerce];
    return p;
}

@end
