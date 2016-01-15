//
//  SettingRequestTool.h
//  BusinessScale
//
//  Created by Alvin on 16/1/13.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "ALWorkRequest.h"

@interface SettingRequestTool : ALWorkRequest

+ (ALRequestParam *)addPayAccountWith:(NSDictionary *)params;
+ (ALRequestParam *)feedbackWithContent:(NSString *)content;
/**
 * 获取收款人账号 GET /thirdpay/account
 */
+ (ALRequestParam *)getPayAccounts:(NSString *)third_uuid;
/**
 * 删除收款人账号
 */
+ (ALRequestParam *)deleteAccount:(NSString *)third_uuid;
@end
