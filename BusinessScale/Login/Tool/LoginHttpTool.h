//
//  LoginHttpTool.h
//  BusinessScale
//
//  Created by Alvin on 15/12/28.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "ALWorkRequest.h"

@interface LoginHttpTool : ALWorkRequest
/**
 * 登录
 */
+ (ALRequestParam *)loginWithParams:(NSDictionary *)params;
/**
 * 登出
 */
+ (ALRequestParam *)loginOut;
/**
 * 注册
 */
+ (ALRequestParam *)registWithParams:(NSDictionary *)params;
/**
 * 获取短信验证码
 */
+ (ALRequestParam *)getVeryCodeWithParams:(NSDictionary *)params;

/**
 * 忘记密码
 */
+ (ALRequestParam *)forgetPasswordWithParams:(NSDictionary *)params;
/**
 * 登录用户重置密码
 */
+ (ALRequestParam *)updatePassWordWithParams:(NSDictionary *)params;
@end
