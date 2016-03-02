//
//  GoodsSwapCell.h
//  BusinessScale
//
//  Created by Alvin on 15/12/15.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "SWTableViewCell.h"
@class SaleItem;
@interface GoodsSwapCell : UITableViewCell

@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *goodsL;
@property (nonatomic, strong) UILabel *weightL;
@property (nonatomic, strong) UILabel *priceL;

@property (nonatomic, strong) UILabel *sepB; // 下分割线

@property (nonatomic, strong) SaleItem *item;


@end
