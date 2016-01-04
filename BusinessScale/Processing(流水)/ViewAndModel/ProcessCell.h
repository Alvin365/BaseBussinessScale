//
//  ProcessCell.h
//  BusinessScale
//
//  Created by Alvin on 15/12/18.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaleModel.h"
@interface ProcessCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *goods;
@property (weak, nonatomic) IBOutlet UILabel *weight;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageV;

@property (nonatomic, strong) SaleItem *item;

- (void)showTopSeparaLine;

@end
