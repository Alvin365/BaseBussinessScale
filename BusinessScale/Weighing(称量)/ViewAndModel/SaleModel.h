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

@property (nonatomic, strong) GoodsInfoModel *goods;// 商品信息
@property (nonatomic, assign) float quantity; // 重量
@property (nonatomic, assign) float unit; // 单位
@property (nonatomic, assign) float price; // 价钱
@property (nonatomic, strong) NSDate *date; // 交易时间

@end

/**
 * 这个类 用来记录每次交易的记录(点击结算成功后，插入新数据)
 */
@interface SaleTable : BaseModel

@property (nonatomic, strong) NSArray *saleItems;
@property (nonatomic, strong) NSDate *date; // 交易时间
@property (nonatomic, assign) float total_fee;
@property (nonatomic, assign) float paid_fee;
@property (nonatomic, copy) NSString *payType;
@property (nonatomic, assign) BOOL isUpLoad; // 是否已经上传

@end
