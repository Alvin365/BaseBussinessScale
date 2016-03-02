//
//  GlobalHttpTool.m
//  BusinessScale
//
//  Created by Alvin on 16/2/25.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "GlobalHttpTool.h"

@implementation GlobalHttpTool
+ (ALRequestParam *)getWeixinAccessTokenWithCode:(NSString *)code
{
    
    
    ALRequestParam *p = [[ALRequestParam alloc]init];
    p.method = ALHttpPost;
//    p.taskType = ALTaskType_UpLoad;
    p.urlString = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",kAppID,kAppSecret,code];
    return p;
}
@end
