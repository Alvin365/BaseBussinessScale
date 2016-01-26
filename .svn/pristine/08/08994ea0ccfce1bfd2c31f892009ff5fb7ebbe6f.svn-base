//
//  GoodsInfoModel.h
//  BusinessScale
//
//  Created by Alvin on 15/12/18.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "BaseModel.h"

/**
 * 商品设置表
 */
@interface GoodsInfoModel : BaseModel

@property (nonatomic, copy) NSString *uid; // 用户ID
@property (nonatomic, copy) NSString *mac; // mac地址

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger unit_price;
@property (nonatomic, copy) NSNumber *number;
@property (nonatomic, assign) WeightUnit unit;
/** 蓝牙数据是否已同步*/
@property (nonatomic, assign) BOOL isSychro; // 是否已经和蓝牙同步

@end

/**
 * 商品设置临时表(修改后，需要同步的列表)
 */
@interface GoodsTemp : GoodsInfoModel

@end


