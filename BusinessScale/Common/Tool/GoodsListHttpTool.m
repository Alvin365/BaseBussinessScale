//
//  GoodsListHttpTool.m
//  BusinessScale
//
//  Created by Alvin on 16/1/19.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "GoodsListHttpTool.h"

@implementation GoodsListHttpTool

+ (ALRequestParam *)coverCoodsListSeverse:(NSArray *)body;
{
    ALRequestParam *p = [[ALRequestParam alloc]init];
    [p addHeader:[AccountTool account].token forKey:@"cs-token"];
    [p addHeader:@"text/plain" forKey:@"Content-Type"];
    p.method = ALHttpPut;
    p.taskType = ALTaskType_UpLoad;
    [p setHttpBody:body];
    p.urlString = [NSString stringWithFormat:@"%@inventory",userServerce];
    return p;
}

+ (ALRequestParam *)postCoodsListSeverse:(NSDictionary *)body;
{
    ALRequestParam *p = [[ALRequestParam alloc]init];
    [p addHeader:[AccountTool account].token forKey:@"cs-token"];
    [p addHeader:@"text/plain" forKey:@"Content-Type"];
    p.method = ALHttpPost;
    p.taskType = ALTaskType_UpLoad;
    [p setHttpBody:body];
    p.urlString = [NSString stringWithFormat:@"%@inventory",userServerce];
    return p;
}

+ (ALRequestParam *)getGoodsListFromSeverse
{
    ALRequestParam *p = [[ALRequestParam alloc]init];
    [p addHeader:[AccountTool account].token forKey:@"cs-token"];
    p.method = ALHttpGet;
    p.taskType = ALTaskType_DataTask;
    p.urlString = [NSString stringWithFormat:@"%@inventory",userServerce];
    return p;
}

+ (ALRequestParam *)upLoadWithImage:(UIImage *)image
{
    ALRequestParam *p = [[ALRequestParam alloc]init];
    [p addHeader:[AccountTool account].token forKey:@"cs-token"];
    [p addHeader:@"application/octet-stream" forKey:@"Content-Type"];
    p.method = ALHttpPut;
    p.taskType = ALTaskType_UpLoad;
    [p setHttpBody:UIImageJPEGRepresentation(image, 1.0)];
//    [p setHttpBody:UIImageJPEGRepresentation(image, 1.0)];
//    [p addJPEGFile:image forKey:@"icon" fileName:@"icon"];
    p.urlString = [NSString stringWithFormat:@"%@inventory/icon",userServerce];
    return p;
}

@end
