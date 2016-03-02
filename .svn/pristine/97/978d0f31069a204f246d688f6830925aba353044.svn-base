//
//  ProcessCell.m
//  BusinessScale
//
//  Created by Alvin on 15/12/18.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "ProcessCell.h"

@interface ProcessCell()


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weightRight;


@end

@implementation ProcessCell

- (void)awakeFromNib {
    self.clipsToBounds = YES;
    _weightRight.constant = 95*ALScreenScalWidth;
    _goodsImageV.layer.cornerRadius = 22.5f;
    _goodsImageV.layer.masksToBounds = YES;
    _goodsImageV.backgroundColor = [UIColor greenColor];
    _goods.textColor = ALTextColor;
    _weight.textColor = ALLightTextColor;
    _priceL.textColor = ALNavBarColor;
    
    _sepT = [[UILabel alloc]init];
    _sepT.backgroundColor = separateLabelColor;
    [self addSubview:_sepT];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.sepT.frame = CGRectMake(25, 0, self.width-25, 0.5);
}

- (void)setItem:(SaleItem *)item
{
    _item = item;
    CGFloat scale = (CGFloat)[UnitTool defaultUnit]/item.unit;
    CGFloat quantity = item.quantity/scale;
    
    [_goodsImageV setImageWithIcon:item.icon];
    _goods.text = item.title;
    _priceL.text = [NSString stringWithFormat:@"%@元",[ALCommonTool decimalPointString:(item.paid_price)/100.0f]];
    _weight.text = [NSString stringWithFormat:@"%@%@",[ALCommonTool decimalPointString:quantity],[UnitTool stringFromWeight:[UnitTool defaultUnit]]];
    if ([UnitTool defaultUnit]==WeightUnit_Gram) {
        _weight.text = [NSString stringWithFormat:@"%li%@",(long)quantity,[UnitTool stringFromWeight:[UnitTool defaultUnit]]];
    }

    [self setNeedsDisplay];
}

- (void)showTopSeparaLine
{
    self.sepT.hidden = NO;
}

@end
