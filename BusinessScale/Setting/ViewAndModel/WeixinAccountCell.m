//
//  WeixinAccountCell.m
//  BusinessScale
//
//  Created by Alvin on 16/3/10.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "WeixinAccountCell.h"

@interface WeixinAccountCell ()

@property (weak, nonatomic) IBOutlet UIView *contents;
@property (weak, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UIView *managerView;
@property (weak, nonatomic) IBOutlet UILabel *flagL;
@property (weak, nonatomic) IBOutlet UILabel *wechatL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weichatLCenterY;

@property (weak, nonatomic) IBOutlet UILabel *acuseLabel;
@property (weak, nonatomic) IBOutlet UIImageView *accuseImag;
@property (weak, nonatomic) IBOutlet UIButton *operatBtn;
@property (weak, nonatomic) IBOutlet UIView *rightView;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headImag;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accusCenterY;

@end

@implementation WeixinAccountCell

- (void)awakeFromNib {
    self.backgroundColor = [UIColor colorWithHexString:@"464646"];
    _headView.backgroundColor = [UIColor colorWithHexString:@"6bc86b"];
    _contents.layer.cornerRadius = 5;
    _contents.layer.masksToBounds = YES;
    
    _weichatLCenterY.constant = 0;
    _flagL.hidden = YES;
    _managerView.hidden = YES;
    _rightView.backgroundColor = backGroudColor;
    
    _nickName.textColor = ALTextColor;
    _acuseLabel.textColor = ALTextColor;
    [_operatBtn setTitleColor:ALTextColor forState:UIControlStateNormal];
    _operatBtn.layer.cornerRadius = 5;
    _operatBtn.layer.masksToBounds = YES;
    _operatBtn.layer.borderColor = separateLabelColor.CGColor;
    _operatBtn.layer.borderWidth = 0.7;
    
    _headImag.layer.cornerRadius = 30;
    _headImag.layer.masksToBounds = YES;
}

- (IBAction)btnClick:(UIButton *)sender {
    if (self.callBack) {
        self.callBack((WeixinCellButtonTag )(sender.tag));
    }
}

- (void)setModel:(PayAccountModel *)model
{
    _model = model;
    if (model) {
        _weichatLCenterY.constant = -10;
        _flagL.hidden = NO;
        _managerView.hidden = NO;
        _addBtn.hidden = YES;
        if (model.mplink) {
//            _operatBtn.hidden = YES;
//            _accusCenterY.constant = 0;
            _accuseImag.image = [UIImage imageNamed:@"已关注"];
            _acuseLabel.text = @"已关注";
        }else{
//            _operatBtn.hidden = NO;
//            _accusCenterY.constant = -15;
            _accuseImag.image = [UIImage imageNamed:@"未关注"];
            _acuseLabel.text = @"未关注";
        }
        [_headImag sd_setImageWithURL:[NSURL URLWithString:model.headimgurl] placeholderImage:[UIImage imageNamed:@"role_head_default.png"]];
        _nickName.text = model.nickname;
    }else{
        _weichatLCenterY.constant = 0;
        _flagL.hidden = YES;
        _managerView.hidden = YES;
        _addBtn.hidden = NO;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
