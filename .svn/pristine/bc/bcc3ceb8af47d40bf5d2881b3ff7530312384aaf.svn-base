//
//  ProcessCell.m
//  BusinessScale
//
//  Created by Alvin on 15/12/18.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "ProcessCell.h"

@interface ProcessCell()

@property (nonatomic, strong) UILabel *sepT;
@property (nonatomic, strong) UILabel *sepB;

@end

@implementation ProcessCell

- (void)awakeFromNib {
    self.clipsToBounds = YES;
    _goodsImageV.layer.cornerRadius = 22.5f;
    _goodsImageV.layer.masksToBounds = YES;
    _goodsImageV.backgroundColor = [UIColor greenColor];
    _goods.textColor = ALTextColor;
    _weight.textColor = ALLightTextColor;
    _priceL.textColor = ALNavBarColor;
    
    _sepT = [[UILabel alloc]init];
    _sepT.backgroundColor = separateLabelColor;
    [self addSubview:_sepT];
    _sepT.hidden = YES;
    
    _sepB = [[UILabel alloc]init];
    _sepB.backgroundColor = separateLabelColor;
    [self addSubview:_sepB];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.sepT.frame = CGRectMake(0, 0, self.width, 0.5);
    self.sepB.frame = CGRectMake(0, self.height-0.5, self.width, 0.5);
}

- (void)setItem:(SaleItem *)item
{
    _item = item;
    CGFloat scale = [UnitTool defaultUnit]/item.unit;
    CGFloat quantity = item.quantity/scale;
    
    NSString *icon = [[item.icon componentsSeparatedByString:@"/"]lastObject];
    _goodsImageV.image = [UIImage imageNamed:icon];
    _goods.text = item.title;
    _priceL.text = [NSString stringWithFormat:@"%g元",(item.unit_price*item.quantity)/100.0f];
    if ([[_priceL.text componentsSeparatedByString:@"."] lastObject].length>2) {
        _priceL.text = [NSString stringWithFormat:@"%.2f元",(item.unit_price*item.quantity)/100.0f];
    }
    _weight.text = [NSString stringWithFormat:@"%.2f%@",quantity,[UnitTool stringFromWeight:[UnitTool defaultUnit]]];
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
