//
//  CategoryCell.m
//  BusinessScale
//
//  Created by Alvin on 16/1/8.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "CategoryCell.h"

@interface CategoryCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weightRight;

@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *weightL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;

@end

@implementation CategoryCell

- (void)awakeFromNib {
    _left.constant = 70;
    _weightRight.constant = 150*ALScreenScalWidth;
    
    _timeL.textColor = ALTextColor;
    _weightL.textColor = ALLightTextColor;
    _priceL.textColor = ALNavBarColor;
    
    _sepT = [[UILabel alloc]init];
    _sepT.backgroundColor = separateLabelColor;
    [self addSubview:_sepT];
    
    _sepB = [[UILabel alloc]init];
    _sepB.backgroundColor = separateLabelColor;
//    [self addSubview:_sepB];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.sepT.frame = CGRectMake(0, 0, self.width, 0.5);
    self.sepB.frame = CGRectMake(0, self.height-0.5, self.width, 0.5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(SaleItem *)item
{
    _item = item;
    CGFloat scale = [UnitTool defaultUnit]/item.unit;
    CGFloat quantity = item.quantity/scale;
    
    _priceL.text = [NSString stringWithFormat:@"%g元",(item.unit_price*item.quantity)/100.0f];
    if ([[_priceL.text componentsSeparatedByString:@"."] lastObject].length>2) {
        _priceL.text = [NSString stringWithFormat:@"%.2f元",(item.unit_price*item.quantity)/100.0f];
    }
    _weightL.text = [NSString stringWithFormat:@"%.2f%@",quantity,[UnitTool stringFromWeight:[UnitTool defaultUnit]]];
    if ([UnitTool defaultUnit]==WeightUnit_Gram) {
        _weightL.text = [NSString stringWithFormat:@"%li%@",(long)quantity,[UnitTool stringFromWeight:[UnitTool defaultUnit]]];
    }
    NSDate *date = [NSDate dateWithTimeIntervalInMilliSecondSince1970:item.ts];
    _timeL.text = [NSString stringWithFormat:@"%02d:%02d",(int)date.hour,(int)date.minute];
    
    [self setNeedsDisplay];
}

@end
