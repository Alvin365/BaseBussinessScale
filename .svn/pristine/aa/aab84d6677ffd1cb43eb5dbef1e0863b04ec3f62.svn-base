//
//  IncomeView.m
//  BusinessScale
//
//  Created by Alvin on 16/1/16.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "ALInComeView.h"

@interface ALInComeView()

@property (weak, nonatomic) IBOutlet UILabel *zeroSep;
@property (weak, nonatomic) IBOutlet UILabel *zeroLabel;

@end

@implementation ALInComeView

+ (instancetype)loadXibIncomeView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ALInComeView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    _title.textColor = ALTextColor;
    _priceFlag.textColor = ALNavBarColor;
    _priceL.textColor = ALNavBarColor;
    _zeroSep.backgroundColor = [UIColor whiteColor];
    _zeroLabel.backgroundColor = ALNavBarColor;
}

- (void)setPriceShow:(BOOL)show
{
    _priceFlag.hidden = !show;
    _priceL.hidden = !show;
    _zeroSep.hidden = show;
    _zeroLabel.hidden = show;
}

@end
