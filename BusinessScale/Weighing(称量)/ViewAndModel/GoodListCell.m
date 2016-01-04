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
    self.imageView.frame = CGRectMake(20, self.height/2.0f-20, 40, 40);
    self.textLabel.frame = CGRectMake(self.imageView.right+20, self.height/2.0f-10, 300, 20);
    self.textLabel.textColor = ALTextColor;
    self.textLabel.font = [UIFont systemFontOfSize:15];
}

- (void)setModel:(GoodsInfoModel *)model
{
    _model = model;
    NSString *icon = [[model.icon componentsSeparatedByString:@"/"]lastObject];
    self.imageView.image = [UIImage imageNamed:icon];
    self.textLabel.text = _model.title;
}
@end
