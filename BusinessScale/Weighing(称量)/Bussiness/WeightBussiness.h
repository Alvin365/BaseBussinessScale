//
//  WeightBussiness.h
//  BusinessScale
//
//  Created by Alvin on 15/12/29.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SaleModel.h"
@interface WeightBussiness : NSObject


@end

@interface WeightBussiness(GoodsList) // 商品列表

- (void)getGoodsListCompletedBlock:(void(^)(NSArray *))block;

@end