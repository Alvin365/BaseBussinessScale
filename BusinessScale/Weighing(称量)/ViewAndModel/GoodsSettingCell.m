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

@property (strong, nonatomic) UIView *deleteView;

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
    _numberLeading.constant = 190.0f*ALScreenScalWidth;
    _priceLeading.constant = 7.0f*ALScreenScalWidth;
    
    [self addSubview:self.sepB];
    
    _deleteView = [[UIView alloc]init];
    _deleteView.alpha = 0.3;
    _deleteView.backgroundColor = [UIColor blackColor];
    _deleteView.userInteractionEnabled = YES;
    [_deleteView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteViewReceiver)]];
    [self addSubview:_deleteView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    if (_model.isDelete) {
////        [super setSelected:NO animated:NO];
//        return;
//    }
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(GoodsTempList *)model
{
    _model = model;
    
    [_imageV setImageWithIcon:model.icon];
    
    _name.text = model.title;
    _number.text = [NSString stringWithFormat:@"%d",(int)model.number];
    _price.text = [NSString stringWithFormat:@"%@元/%@",[ALCommonTool decimalPointString:(int)model.unit_price/100.0f],[UnitTool stringFromWeight:model.unit]];
    
    _deleteView.hidden = !model.isDelete;
    _syChroFlagImage.hidden = [ScaleTool scale].mac.length?!model.isSychro:YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.sepB.frame = CGRectMake(0, self.height-0.5, self.width, 0.5);
    self.deleteView.frame = CGRectMake(0, 0, self.width, self.height);
}

- (void)deleteViewReceiver
{
    [MBProgressHUD showMessage:@"该商品已删除，不能编辑"];
    ALLog(@"deleteViewReceiver");
}

@end
