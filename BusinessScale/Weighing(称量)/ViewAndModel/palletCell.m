//
//  palletCell.m
//  BusinessScale
//
//  Created by Alvin on 15/12/16.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "palletCell.h"

@implementation palletCellModel



@end

@interface palletCell()

@property (weak, nonatomic) IBOutlet UIView *seletedBtn;
@property (weak, nonatomic) IBOutlet UILabel *goods;
@property (weak, nonatomic) IBOutlet UILabel *weight;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageV;
@property (weak, nonatomic) IBOutlet UIImageView *seleteImageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsImageLeadingConstraint;

@property (nonatomic, strong) UILabel *sepT;
@property (nonatomic, strong) UILabel *sepB;

@end

@implementation palletCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
    }
    return self;
}

- (void)awakeFromNib {
    _goodsImageV.layer.cornerRadius = 22.5f;
    _goodsImageV.layer.masksToBounds = YES;
    _goodsImageV.backgroundColor = [UIColor greenColor];
    _goods.textColor = ALTextColor;
    _weight.textColor = ALLightTextColor;
    _priceL.textColor = ALNavBarColor;
    
    [_seletedBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectClick)]];
    
    _sepT = [[UILabel alloc]init];
    _sepT.backgroundColor = separateLabelColor;
    [self addSubview:_sepT];
    
    _sepB = [[UILabel alloc]init];
    _sepB.backgroundColor = separateLabelColor;
    [self addSubview:_sepB];
}

- (void)selectClick
{
    _model.isSelected = !_model.isSelected;
    if (self.callBack) {
        self.callBack (self);
    }
}

- (void)setModel:(palletCellModel *)model
{
    _model = model;
    if (model.isSelected) {
        _seleteImageV.image = [UIImage imageNamed:@"icon_sel"];
    }else{
        _seleteImageV.image = [UIImage imageNamed:@"icon_nor"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.sepT.frame = CGRectMake(0, 0, self.width, 0.5);
    self.sepB.frame = CGRectMake(0, self.height-0.5, self.width, 0.5);
}

@end
