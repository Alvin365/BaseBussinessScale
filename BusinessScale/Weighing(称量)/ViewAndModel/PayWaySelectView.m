//
//  PayWaySelectView.m
//  BusinessScale
//
//  Created by Alvin on 15/12/18.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "PayWaySelectView.h"

@interface PayWaySelectView()
{
    BOOL _animate;
}
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *realView;
@property (weak, nonatomic) IBOutlet ALTextField *realPriceTextField;
@property (weak, nonatomic) IBOutlet UILabel *realFlag;
@property (weak, nonatomic) IBOutlet UILabel *realUnit;

@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *crashPay;
@property (weak, nonatomic) IBOutlet UILabel *wechatPay;
@property (weak, nonatomic) IBOutlet UILabel *alipay;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewRight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *realPriceHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *realTextFieldHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *crashHeight;

@end

@implementation PayWaySelectView

- (void)awakeFromNib
{
    [self initUIFromXib];
    [self initConstraint];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    [_crashPay addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(payWay:)]];
    [_wechatPay addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(payWay:)]];
    [_alipay addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(payWay:)]];
}

- (void)initUIFromXib
{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 5;
    _contentView.layer.masksToBounds = YES;
    
    _priceL.textColor = ALTextColor;
    _realFlag.textColor = ALTextColor;
    _realUnit.textColor = ALTextColor;
    _realPriceTextField.inputField.textColor = ALLightTextColor;
    _realPriceTextField.backgroundColor = [UIColor whiteColor];
    _realPriceTextField.cornerRadius = 5;
    _realPriceTextField.inputField.textAlignment = NSTextAlignmentRight;
    _realPriceTextField.inputField.keyboardType = UIKeyboardTypeDecimalPad;
    
    _realView.backgroundColor = backGroudColor;
    _crashPay.backgroundColor = [UIColor colorWithHexString:@"ff9928"];
    _wechatPay.backgroundColor = [UIColor colorWithHexString:@"60c90f"];
    _alipay.backgroundColor = [UIColor colorWithHexString:@"00abe8"];
}

- (void)initConstraint
{
    _contentViewTop.constant = _contentViewBottom.constant = 133.5*ALScreenScalHeight;
    _contentViewLeft.constant = _contentViewRight.constant = 15*ALScreenScalWidth;
    _priceHeight.constant = 65*ALScreenScalHeight;
    _realPriceHeight.constant = 110*ALScreenScalHeight;
    _realTextFieldHeight.constant = 50*ALScreenScalHeight;
    _crashHeight.constant = 75*ALScreenScalHeight;
}

- (IBAction)btnClick:(UIButton *)sender
{
    [self hide];
}

#pragma mark -Method
+ (instancetype)loadXibView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PayWaySelectView" owner:nil options:nil] firstObject];
}

- (void)showAnimate:(BOOL)animate
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    _animate = animate;
    if (!animate) {
        return;
    }
    [_contentView.layer layerZoomIn];
}

- (void)hide
{
    if (!_animate) {
        [self removeFromSuperview];
        return;
    }
    [_contentView.layer layerZoomOut];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}

- (void)tap
{
    [self hide];
}

- (void)payWay:(UIGestureRecognizer *)reconize
{
    UILabel *l = (UILabel *)reconize.view;
    if (self.callBack) {
        self.callBack((PayWayType)l.tag);
    }
}

@end
