//
//  RecordSectionView.m
//  BusinessScale
//
//  Created by Alvin on 15/12/18.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "RecordSectionView.h"

@interface RecordSectionView()
@property (weak, nonatomic) IBOutlet UILabel *priceFlag;
@property (weak, nonatomic) IBOutlet UIImageView *timeImageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLeadingCons;

@property (nonatomic, strong) UILabel *sepT;
@property (nonatomic, strong) UILabel *sepB;

@end

@implementation RecordSectionView

+ (instancetype)loadXibView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"RecordSectionView" owner:nil options:nil] firstObject];
}

- (UILabel *)sepT
{
    if (!_sepT) {
        _sepT = [[UILabel alloc]init];
        _sepT.backgroundColor = separateLabelColor;
        [self addSubview:_sepT];
    }
    return _sepT;
}

- (UILabel *)sepB
{
    if (!_sepB) {
        _sepB = [[UILabel alloc]init];
        _sepB.backgroundColor = separateLabelColor;
        [self addSubview:_sepB];
    }
    return _sepB;
}

- (void)awakeFromNib
{
    self.backgroundColor = backGroudColor;
    _dateL.textColor = ALTextColor;
    _priceL.textColor = ALTextColor;
    _priceFlag.textColor = [UIColor whiteColor];
    _priceFlag.backgroundColor = ALRedColor;
    _priceFlag.layer.cornerRadius = _priceFlag.height/2.0f;
    _priceFlag.layer.masksToBounds = YES;
    
    self.timeImageV.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.sepT.frame = CGRectMake(0, 0, self.width, 0.5);
//    self.sepB.frame = CGRectMake(0, self.height-0.5, self.width, 0.5);
}

- (void)turnIntoProcessSecctionView
{
    self.timeImageV.hidden = NO;
    self.dateLeadingCons.constant = 50;
}

@end
