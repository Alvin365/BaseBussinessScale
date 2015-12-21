//
//  RecordCell.m
//  BusinessScale
//
//  Created by Alvin on 15/12/18.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "RecordCell.h"

@interface RecordCell()

@property (nonatomic, strong) UILabel *sepT;
@property (nonatomic, strong) UILabel *sepB;

@end

@implementation RecordCell

- (UILabel *)sepT
{
    if (!_sepT) {
        _sepT = [[UILabel alloc]init];
        _sepT.backgroundColor = separateLabelColor;
        _sepT.hidden = YES;
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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(GoodsInfoModel *)model
{
    _model = model;
    self.imageView.image = [UIImage imageNamed:model.icon];
    self.textLabel.text = model.name;
    self.detailTextLabel.text = model.price;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(15, self.height/2.0f-15, 30, 30);
    self.textLabel.frame = CGRectMake(self.imageView.right+20, self.height/2.0f-10, 200, 20);
    self.detailTextLabel.frame = CGRectMake(self.width-200, self.height/2.0f-10, 180, 20);
    
    self.textLabel.textColor = ALLightTextColor;
    self.detailTextLabel.textColor = ALNavBarColor;
    
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.detailTextLabel.font = [UIFont systemFontOfSize:17];
    
    self.sepT.frame = CGRectMake(0, 0, self.width, 0.5);
    self.sepB.frame = CGRectMake(0, self.height-0.5, self.width, 0.5);
}

- (void)showTopSeparaLine
{
    self.sepT.hidden = NO;
}

@end
