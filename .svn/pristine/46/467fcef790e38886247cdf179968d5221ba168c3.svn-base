//
//  GoodListCell.m
//  BusinessScale
//
//  Created by Alvin on 15/12/18.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "GoodListCell.h"

@implementation GoodListCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(20, self.height/2.0f-17.5, 35, 35);
    self.textLabel.frame = CGRectMake(self.imageView.right+20, self.height/2.0f-10, 100, 20);
    self.textLabel.textColor = ALTextColor;
    self.textLabel.font = [UIFont systemFontOfSize:15];
}

- (void)setModel:(GoodsInfoModel *)model
{
    _model = model;
    self.imageView.image = [UIImage imageNamed:model.icon];
    self.textLabel.text = _model.name;
}
@end
