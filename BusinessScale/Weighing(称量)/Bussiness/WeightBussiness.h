//
//  WeightBussiness.h
//  BusinessScale
//
//  Created by Alvin on 15/12/29.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SaleModel.h"
@class TransactionData;
@interface WeightBussiness : NSObject
/**
 * 处理被动收款数据
 */
+ (void)dealPassivityWithArray:(NSArray *)datas CompletedBlock:(void(^)(NSDictionary *params,CGFloat price))block;

/**
 * 上传历史数据
 */
+ (void)upLoadHistories:(NSArray *)datas;

/**
 * @param totals_fee 订单总支付价格
 * @param paid_fee 订单实际支付价格
 * @param dataArray SaleItem的数组
 * @return 上传订单接口参数
 */

+ (NSDictionary *)upLoadDatasTransfer:(NSInteger)totals_fee payFee:(NSInteger)paid_fee datas:(NSArray *)dataArray;

/**
 * 上传服务器的订单 写入本地服务器
 * @param orderDic 订单数据
 */
+ (void)orderInsertToLocalSever:(NSDictionary *)orderDic;

/**
 * 解析蓝牙数据
 * @param data 蓝牙数据
 */
+ (NSDictionary *)blueToothDataTransfer:(TransactionData *)data;

@end

@interface WeightBussiness(GoodsList) // 商品列表

- (void)getGoodsListCompletedBlock:(void(^)(NSArray *))block category:(BOOL)isCategory;

@end