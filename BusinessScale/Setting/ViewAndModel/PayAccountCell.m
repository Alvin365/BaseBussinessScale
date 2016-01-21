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

@property (weak, nonatomic) IBOutlet UIView *payWayView;
@property (weak, nonatomic) IBOutlet UIImageView *payWayImage;
@property (weak, nonatomic) IBOutlet UILabel *payWayName;
@property (weak, nonatomic) IBOutlet UIView *emailView;
@property (weak, nonatomic) IBOutlet UILabel *emailLable;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teleLabel;

@property (weak, nonatomic) IBOutlet UIView *addOrManageView;
@property (weak, nonatomic) IBOutlet UIImageView *addImage;
@property (weak, nonatomic) IBOutlet UILabel *addOrManagerLabel;

@end

@implementation PayAccountCell

- (void)awakeFromNib {
    _realView.backgroundColor = [UIColor whiteColor];
    _realView.layer.cornerRadius = 5;
    _realView.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor colorWithHexString:@"464646"];
    [_addOrManageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    _addOrManageView.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setType:(PayWayType)type
{
    _type = type;
    if (type == PayWayTypeAlipay) {
        _payWayImage.image = [UIImage imageNamed:@"支付宝2"];
        _payWayName.text = @"支付宝";
        _payWayView.backgroundColor = [UIColor colorWithHexString:@"00abe8"];
    }else{
        _payWayImage.image = [UIImage imageNamed:@"微信2"];
        _payWayName.text = @"微信支付";
        _payWayView.backgroundColor = [UIColor colorWithHexString:@"6bc86b"];
    }
}

- (void)setIsManager:(BOOL)isManager
{
    _isManager = isManager;
    if (isManager) {
        _addImage.hidden = YES;
        _addOrManagerLabel.text = @"管理";
        _emailView.hidden = _nameLabel.hidden = _teleLabel.hidden = NO;
    }else{
        _addImage.hidden = NO;
        _addOrManagerLabel.text = @"添加";
        _emailView.hidden = _nameLabel.hidden = _teleLabel.hidden = YES;
    }
    [self layoutIfNeeded];
}

- (void)setModel:(PayAccountModel *)model
{
    _model = model;
    if (model) {
        _addImage.hidden = YES;
        _addOrManagerLabel.text = @"管理";
        _emailLable.text = model.third_id;
        _nameLabel.text = model.realname;
        _teleLabel.text = model.phone;
        _emailView.hidden = _nameLabel.hidden = _teleLabel.hidden = NO;
    }else{
        _addImage.hidden = NO;
        _addOrManagerLabel.text = @"添加";
        _emailView.hidden = _nameLabel.hidden = _teleLabel.hidden = YES;
    }
    _isManager = model!=nil;
}

- (void)tap
{
    if (self.callBack) {
        self.callBack(_isManager);
    }
}

+ (CGFloat)cellHeightForIsManager:(BOOL)isManager
{
    if (isManager) {
        return 210;
    }
    return 85;
}
@end
