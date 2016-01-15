//
//  MyAccountCell.m
//  BusinessScale
//
//  Created by Alvin on 16/1/14.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "MyAccountCell.h"

@implementation MyAccountCell

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
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.textColor = ALTextColor;
    self.textLabel.font = [UIFont systemFontOfSize:16];
    self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    self.textLabel.frame = CGRectMake(15, self.height/2.0f-10, 200, 20);
    _rightArrow.frame = CGRectMake(screenWidth-22, self.height/2.0f-5.25, 7, 10.5);
}

@end
