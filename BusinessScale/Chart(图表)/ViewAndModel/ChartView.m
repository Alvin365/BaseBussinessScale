//
//  ChartView.m
//  BusinessScale
//
//  Created by Alvin on 16/1/10.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "ChartView.h"

@interface ChartView()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segMent;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *totalView;
@property (weak, nonatomic) IBOutlet UIView *averageView;
@property (weak, nonatomic) IBOutlet UIView *mostView;
@property (weak, nonatomic) IBOutlet UIView *leastView;


@property (weak, nonatomic) IBOutlet UILabel *dayMoneyL;
@property (weak, nonatomic) IBOutlet UILabel *totalFlagL;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceFlagL;

@property (weak, nonatomic) IBOutlet UILabel *averageFlagL;
@property (weak, nonatomic) IBOutlet UILabel *averagePrice;
@property (weak, nonatomic) IBOutlet UILabel *averagePriceFlag;

@property (weak, nonatomic) IBOutlet UILabel *mostTopFlag;
@property (weak, nonatomic) IBOutlet UILabel *mostDate;
@property (weak, nonatomic) IBOutlet UILabel *mostPriceL;
@property (weak, nonatomic) IBOutlet UILabel *mostPriceFlag;


@property (weak, nonatomic) IBOutlet UILabel *leastFlag;
@property (weak, nonatomic) IBOutlet UILabel *leastDate;
@property (weak, nonatomic) IBOutlet UILabel *leastPriceL;
@property (weak, nonatomic) IBOutlet UILabel *leastPriceFlag;

@end

@implementation ChartView

+ (instancetype)loadXibView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ChartView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    _topView.backgroundColor =ALNavBarColor;
    
    _segMent.backgroundColor =ALNavBarColor;
    _dayMoneyL.textColor =ALNavBarColor;
    
    _totalFlagL.textColor = ALTextColor;
    _averageFlagL.textColor = ALTextColor;
    _totalPriceFlagL.textColor = ALNavBarColor;
    _totalPrice.textColor = ALNavBarColor;
    _averagePrice.textColor = ALNavBarColor;
    _averagePriceFlag.textColor = ALNavBarColor;
    
    _mostTopFlag.layer.cornerRadius = 10.0f;
    _mostTopFlag.layer.masksToBounds = YES;
    _mostTopFlag.backgroundColor = ALRedColor;
    _mostDate.textColor = ALTextColor;
    _mostPriceFlag.textColor = ALRedColor;
    _mostPriceL.textColor = ALRedColor;
    
    _leastFlag.layer.cornerRadius = 10.0f;
    _leastFlag.layer.masksToBounds = YES;
    _leastFlag.backgroundColor = [UIColor blueColor];
     _leastDate.textColor = ALTextColor;
    _leastPriceFlag.textColor = [UIColor blueColor];
    _leastPriceL.textColor = [UIColor blueColor];
    
    _totalView.backgroundColor = backGroudColor;
    _averageView.backgroundColor = backGroudColor;
    _mostView.backgroundColor = ALDisAbleColor;
    _leastView.backgroundColor = ALDisAbleColor;
}

@end
