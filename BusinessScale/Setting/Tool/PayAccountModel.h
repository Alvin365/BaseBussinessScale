//
//  PayAccountModel.h
//  BusinessScale
//
//  Created by Alvin on 16/1/21.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "BaseModel.h"

@interface PayAccountModel : BaseModel

@property (nonatomic, assign) int aid;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *realname;
@property (nonatomic, copy) NSString *third_id;
@property (nonatomic, copy) NSString *third_type;
@property (nonatomic, copy) NSString *third_uuid;
@property (nonatomic, copy) NSString *headimgurl;
@property (nonatomic, copy) NSString *nickname;


@end
