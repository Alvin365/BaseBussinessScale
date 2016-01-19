//
//  LevelView.m
//  BusinessScale
//
//  Created by Alvin on 16/1/16.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "LevelView.h"

@implementation LevelView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = backGroudColor;
    _price = [[UILabel alloc]init];
    _levelFlag = [[UILabel alloc]init];
    _levelL = [[UILabel alloc]init];
    _priceFlag = [[UILabel alloc]init];
    
    _price.font = [UIFont systemFontOfSize:22];
    _levelL.font = [UIFont systemFontOfSize:16];
    _levelFlag.font = [UIFont systemFontOfSize:11];
    _priceFlag.font = [UIFont systemFontOfSize:15];
    
    _priceFlag.text = @"￥";
    _levelFlag.layer.cornerRadius = 10;
    _levelFlag.layer.masksToBounds = YES;
    
    _levelFlag.textAlignment = NSTextAlignmentCenter;
    
    _levelFlag.textColor = [UIColor whiteColor];
    _levelL.textColor = ALTextColor;
    
    [self addSubview:_priceFlag];
    [self addSubview:_price];
    [self addSubview:_levelFlag];
    [self addSubview:_levelL];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat priceflagWidth = [_priceFlag.text bundingWithSize:CGSizeMake(screenWidth, 20) Font:15].width;
    CGFloat priceWidth = [_price.text bundingWithSize:CGSizeMake(screenWidth, 27) Font:22].width+10;
    CGFloat levelFlagWith = [_levelFlag.text bundingWithSize:CGSizeMake(screenWidth, 20) Font:11].width + 10;
    CGFloat levelWidth = [_levelL.text bundingWithSize:CGSizeMake(screenWidth, 20) Font:16].width;
    
    CGFloat levelFlagX = (self.width-(levelFlagWith+5+levelWidth))/2.0f;
    CGFloat priceFlagX = (self.width-(priceflagWidth+2+priceWidth))/2.0f;
    
    _levelFlag.frame = CGRectMake(levelFlagX, self.height/2.0f-20, levelFlagWith, 20);
    _levelL.frame = CGRectMake(_levelFlag.right+5, _levelFlag.y, levelWidth, 20);
    _priceFlag.frame = CGRectMake(priceFlagX, self.height/2.0f+5, priceflagWidth, 18);
    _price.frame = CGRectMake(_priceFlag.right+2, _priceFlag.y, priceWidth, 27);
}

- (void)setGlobalColor:(UIColor *)globalColor
{
    _globalColor = globalColor;
    _levelFlag.backgroundColor = _globalColor;
    _priceFlag.textColor = _globalColor;
    _price.textColor = _globalColor;
}

@end
