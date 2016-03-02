//
//  PaySuccessView.m
//  BusinessScale
//
//  Created by Alvin on 16/2/25.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "PaySuccessView.h"

@interface PaySuccessView()
{
    BOOL _animate;
}

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *successLabel;

@property (weak, nonatomic) IBOutlet UILabel *sepT;
@property (weak, nonatomic) IBOutlet UILabel *sepM;
@property (weak, nonatomic) IBOutlet UILabel *sepB;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sepT_H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sepM_H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sepB_H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWith;


@end

@implementation PaySuccessView

+ (instancetype)loadXibView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PaySuccessView" owner:nil options:nil] firstObject];
}

- (IBAction)confirm:(UIButton *)sender {
    [self removeFromSuperview];
}

- (void)awakeFromNib
{
    _contentView.layer.cornerRadius = 10;
    _contentView.layer.masksToBounds = YES;
    _contentView.backgroundColor = [UIColor whiteColor];
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)]];
    
    _successLabel.textColor = ALTextColor;
    _confirmButton.layer.cornerRadius = 5;
    _confirmButton.layer.masksToBounds = YES;
    _confirmButton.backgroundColor = ALNavBarColor;
    
    _sepT_H.constant = 0.5;
    _sepM_H.constant = 0.5;
    _sepB_H.constant = 0.5;
    
    _contentViewWith.constant = 350*ALScreenScalWidth;
}

- (void)showPrice:(NSString *)price order:(NSString *)order animate:(BOOL)animate
{
    self.money.attributedText = [ALCommonTool setAttrbute:@"金额：" andAttribute:[NSString stringWithFormat:@"%@元",[ALCommonTool decimalPointString:([price floatValue]/100.0f)]] Color1:ALLightTextColor Color2:ALTextColor Font1:15 Font2:15];
    
    self.orderLabel.attributedText = [ALCommonTool setAttrbute:@"订单号：" andAttribute:[order substringToIndex:9] Color1:ALLightTextColor Color2:ALTextColor Font1:15 Font2:15];
    [self showAnimate:animate];
}

- (void)showAnimate:(BOOL)animate
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    _animate = animate;
    if (!animate) {
        return;
    }
    [_contentView.layer layerZoomIn];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hide];
    });
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
    [self confirm:nil];
}

@end
