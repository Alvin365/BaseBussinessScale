//
//  AccountTool.h
//  showTalence
//
//  Created by iMAC001 on 15/4/28.
//  Copyright (c) 2015年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountModel : BaseModel<NSCoding>

/** 当前授权用户的ID */
@property (copy, nonatomic) NSString *ID;
/** 用于调用token，接口获取授权后的 token */
@property (nonatomic, copy) NSString *token;
/** token失效的时间 */
@property (nonatomic, copy) NSString *expirytime;
/** 用户昵称 */
@property (nonatomic, copy) NSString *nickName;
/** 用户手机号*/
@property (nonatomic, copy) NSString *phone;
/** 微信号*/
@property (nonatomic, copy) NSString *weichatNo;
/** 支付宝账号*/
@property (nonatomic, copy) NSString *alipayNo;

@property (nonatomic, assign) NSTimeInterval register_ts;

@end

@interface AccountTool : NSObject

+ (void)saveAccount:(AccountModel *)model;
+ (AccountModel *)account;

@end
