//
//  BaseTableViewCell.m
//  BusinessScale
//
//  Created by Alvin on 15/12/18.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

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

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.sepT.frame = CGRectMake(0, 0, self.width, ALSeparaLineHeight);
    self.sepB.frame = CGRectMake(0, self.height-ALSeparaLineHeight, self.width, ALSeparaLineHeight);
}

@end
