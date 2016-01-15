//
//  PayModelTool.h
//  BusinessScale
//
//  Created by Alvin on 16/1/14.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "BaseModel.h"

@interface PayAccountModel : BaseModel<NSCoding>

@property (nonatomic, assign) int aid;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *realname;
@property (nonatomic, copy) NSString *third_id;
@property (nonatomic, copy) NSString *third_type;
@property (nonatomic, copy) NSString *third_uuid;

@end

@interface PayAccountTool : NSObject

+ (void)savePayAccountList:(NSArray *)array;

+ (NSArray *)list;

+ (PayAccountModel *)alipayAccount;

+ (PayAccountModel *)weixinAccount;

@end
