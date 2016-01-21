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
    ALLog(@"%@",[AccountTool account].token);
    ALRequestParam *p = [[ALRequestParam alloc]init];
    [p addHeader:@"application/json" forKey:@"Content-Type"];
    [p addHeader:[AccountTool account].token forKey:@"cs-token"];
    p.method = ALHttpPut;
    p.taskType = ALTaskType_UpLoad;
    for (NSString *key in params.allKeys) {
        [p addParam:params[key] forKey:key];
    }
    [p setHttpBody:params];
    p.urlString = [NSString stringWithFormat:@"%@po",userServerce];
    return p;
}

+ (ALRequestParam *)batchUploadSaleRecords:(NSArray *)body
{
    ALRequestParam *p = [[ALRequestParam alloc]init];
    [p addHeader:[AccountTool account].token forKey:@"cs-token"];
    [p addHeader:@"text/plain" forKey:@"Content-Type"];
    p.method = ALHttpPut;
    p.taskType = ALTaskType_UpLoad;
    [p setHttpBody:body];
    p.urlString = [NSString stringWithFormat:@"%@pobatch",userServerce];
    return p;
}

+ (ALRequestParam *)getPoStatusWithOrderID:(NSString *)orderId
{
    ALRequestParam *p = [[ALRequestParam alloc]init];
    [p addHeader:[AccountTool account].token forKey:@"cs-token"];
    p.method = ALHttpGet;
    p.taskType = ALTaskType_DataTask;
    p.urlString = [NSString stringWithFormat:@"%@postatus/%@",userServerce,orderId];
    return p;
}

@end
