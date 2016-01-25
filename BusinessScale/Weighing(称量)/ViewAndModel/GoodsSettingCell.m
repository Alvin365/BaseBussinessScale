//
//  GoodsSettingCell.m
//  BusinessScale
//
//  Created by Alvin on 15/12/18.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "GoodsSettingCell.h"

@interface GoodsSettingCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UIImageView *syChroFlagImage;
@property (nonatomic, strong) UILabel *sepB;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceLeading;

@end

@implementation GoodsSettingCell

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
    _imageV.layer.cornerRadius = 20.0f;
    _imageV.layer.masksToBounds = YES;
    _name.textColor = ALTextColor;
    _number.textColor = ALLightTextColor;
    _price.textColor = ALNavBarColor;
    
    _imageViewLeading.constant = 12.0f*ALScreenScalWidth;
    _nameLeading.constant = 80.0f*ALScreenScalWidth;
    _numberLeading.constant = 180.0f*ALScreenScalWidth;
    _priceLeading.constant = 7.0f*ALScreenScalWidth;
    
    [self addSubview:self.sepB];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(GoodsInfoModel *)model
{
    _model = model;
    
    [_imageV setImageWithIcon:model.icon];
    
    _name.text = model.title;
    _number.text = [NSString stringWithFormat:@"%ld",(long int)[model.number intValue]];
    _price.text = [NSString stringWithFormat:@"%.2f元/%@",(int)model.unit_price/100.0f,[UnitTool stringFromWeight:model.unit]];
    _syChroFlagImage.hidden = !model.isSychro;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.sepB.frame = CGRectMake(0, self.height-0.5, self.width, 0.5);
}

@end
