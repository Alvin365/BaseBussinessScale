//
//  SettingBussiness.h
//  BusinessScale
//
//  Created by Alvin on 16/1/14.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingBussiness : NSObject
/**
 * 查询本地 商品设置列表
 */
+ (void)searchGoodsettingList:(void(^)(NSArray *unDeleteArray,NSArray *deletedArray))completedBlock;
/**
 * 判断 该物品 是否在商品列表中已存在
 */
+ (void)judgeListHaveThisGoods:(GoodsTempList *)model list:(NSArray *)array completedBlock:(void(^)())comletedBlock;

@end
