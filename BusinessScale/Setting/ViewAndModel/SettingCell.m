//
//  SettingCell.m
//  BusinessScale
//
//  Created by Alvin on 15/12/19.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _rightArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"more"]];
    [self addSubview:_rightArrow];
    
    _segMent = [[UISegmentedControl alloc]initWithItems:@[@"公斤",@"斤",@"两",@"克"]];
    _segMent.tintColor = ALNavBarColor;
    _segMent.backgroundColor = [UIColor whiteColor];
    _segMent.layer.cornerRadius = 7;
    _segMent.layer.borderColor = ALNavBarColor.CGColor;
    _segMent.layer.borderWidth = 0.7;
    _segMent.layer.masksToBounds = YES;
    _segMent.selectedSegmentIndex = 0;
    [_segMent setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateSelected];
    [_segMent setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    [_segMent addTarget:self action:@selector(segComponseSelected:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_segMent];
}

- (void)segComponseSelected:(UISegmentedControl *)seg
{
    if (self.segItemChanged) {
        self.segItemChanged(seg.selectedSegmentIndex);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.textColor = ALTextColor;
    self.textLabel.font = [UIFont systemFontOfSize:16];
    self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    self.textLabel.frame = CGRectMake(15, self.height/2.0f-10, 200, 20);
    _rightArrow.frame = CGRectMake(screenWidth-22, self.height/2.0f-5.25, 7, 10.5);
    _segMent.frame = CGRectMake(screenWidth-15-220*ALScreenScalWidth, self.height/2.0f-20, 220*ALScreenScalWidth, 40);
}

@end
