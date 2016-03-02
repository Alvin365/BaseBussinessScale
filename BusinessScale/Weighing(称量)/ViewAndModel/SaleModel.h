//
//  SaleModel.h
//  BusinessScale
//
//  Created by Alvin on 15/12/29.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "BaseModel.h"

/**
 * 这个类 用来记录每次交易具体的交易商品信息
 */
@interface SaleItem : BaseModel

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *mac;

@property (nonatomic, copy) NSString *title;// 商品信息
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) NSInteger quantity; // 重量
@property (nonatomic, assign) WeightUnit unit; // 单位
@property (nonatomic, assign) NSInteger unit_price; // 价钱
@property (nonatomic, assign) NSTimeInterval ts; // 交易时间
@property (nonatomic, assign) NSInteger total_price;
@property (nonatomic, assign) NSInteger paid_price;
@property (nonatomic, assign) float discount;

@end

/**
 * 这个类 用来记录每次交易的记录(点击结算成功后，插入新数据)
 */
@interface SaleTable : BaseModel

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *mac;
@property (nonatomic, copy) NSString *title;// 商品信息
@property (nonatomic, copy) NSString *randid;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, assign) NSTimeInterval ts; // 交易时间
@property (nonatomic, assign) NSInteger total_fee;
@property (nonatomic, assign) NSInteger paid_fee;
@property (nonatomic, copy) NSString *payment_type;
//@property (nonatomic, assign) BOOL isUpLoad; // 是否已经上传
@property (nonatomic, copy) NSString *po_uuid;

@end
