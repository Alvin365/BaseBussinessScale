//
//  SettingRequestTool.m
//  BusinessScale
//
//  Created by Alvin on 16/1/13.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "SettingRequestTool.h"

@implementation SettingRequestTool

+ (ALRequestParam *)addPayAccountWith:(NSDictionary *)params
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
//    [p setHttpBody:params];
    p.urlString = [NSString stringWithFormat:@"%@thirdpay/account",userServerce];
    return p;
}

+ (ALRequestParam *)feedbackWithContent:(NSString *)content
{
    ALLog(@"%@",[AccountTool account].token);
    ALRequestParam *p = [[ALRequestParam alloc]init];
    [p addHeader:@"application/json" forKey:@"Content-Type"];
    [p addHeader:[AccountTool account].token forKey:@"cs-token"];
    [p addHeader:@"ebcad75de0d42a844d98a755644e30" forKey:@"cs-app-id"];
    p.method = ALHttpPost;
    p.taskType = ALTaskType_UpLoad;
    [p setHttpBody:content];
    [p addParam:content forKey:@"feedback_content"];
    [p addParam:@"ios" forKey:@"platform"];
    [p addParam:[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey] forKey:@"version"];
    [p addParam:[NSString stringWithFormat:@"%@", [[UIDevice currentDevice] systemVersion]] forKey:@"sdk"];
    p.urlString = [NSString stringWithFormat:@"%@feedback",userServerce];
    return p;
}

+ (ALRequestParam *)getPayAccounts:(NSString *)third_uuid
{
    ALLog(@"%@",[AccountTool account].token);
    ALRequestParam *p = [[ALRequestParam alloc]init];
    [p addHeader:@"application/json" forKey:@"Content-Type"];
    [p addHeader:[AccountTool account].token forKey:@"cs-token"];
//    [p addHeader:@"ebcad75de0d42a844d98a755644e30" forKey:@"cs-app-id"];
    p.method = ALHttpGet;
    p.taskType = ALTaskType_DataTask;
    [p addParam:third_uuid forKey:@"third_uuid"];
    p.urlString = [NSString stringWithFormat:@"%@thirdpay/account",userServerce];
    return p;
}

+ (ALRequestParam *)deleteAccount:(NSString *)third_uuid
{
    ALLog(@"%@",[AccountTool account].token);
    ALRequestParam *p = [[ALRequestParam alloc]init];
    [p addHeader:@"application/json" forKey:@"Content-Type"];
    [p addHeader:[AccountTool account].token forKey:@"cs-token"];
    p.method = ALHttpDelete;
    p.taskType = ALTaskType_DataTask;
    [p addParam:third_uuid forKey:@"third_uuid"];
    p.urlString = [NSString stringWithFormat:@"%@thirdpay/account",userServerce];
    return p;
}
@end
