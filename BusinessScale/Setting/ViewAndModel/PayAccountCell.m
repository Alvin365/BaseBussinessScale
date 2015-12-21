//
//  PayAccountCell.m
//  BusinessScale
//
//  Created by Alvin on 15/12/21.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "PayAccountCell.h"

@interface PayAccountCell()

@property (weak, nonatomic) IBOutlet UIView *realView;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIImageView *payWayImage;
@property (weak, nonatomic) IBOutlet UILabel *payWayName;
@property (weak, nonatomic) IBOutlet UILabel *emailLable;
@property (weak, nonatomic) IBOutlet UILabel *separateLine;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separaLineH;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payWayImageTop;

@end

@implementation PayAccountCell

- (void)awakeFromNib {
    _realView.layer.cornerRadius = 5;
    _realView.layer.masksToBounds = YES;
    _realView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = backGroudColor;
    _emailLable.textColor = [UIColor colorWithHexString:@"161616"];
    _separateLine.backgroundColor = separateLabelColor;
    _nameLabel.textColor = [UIColor colorWithHexString:@"9a9a9a"];
    _teleLabel.textColor = [UIColor colorWithHexString:@"9a9a9a"];
    
    _separaLineH.constant = 0.4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setType:(PayWayType)type
{
    _type = type;
    if (type == PayWayTypeAlipay) {
        _payWayImage.image = [UIImage imageNamed:@"支付宝"];
        _payWayName.text = @"支付宝";
        _leftView.backgroundColor = [UIColor colorWithHexString:@"42bfea"];
    }else{
        _payWayImage.image = [UIImage imageNamed:@"微信支付"];
        _payWayName.text = @"微信支付";
        _leftView.backgroundColor = [UIColor colorWithHexString:@"6bc86b"];
    }
}

@end
