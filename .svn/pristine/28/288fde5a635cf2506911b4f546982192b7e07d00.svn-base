//
//  WeightNoDatasView.m
//  BusinessScale
//
//  Created by Alvin on 15/12/24.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "WeightNoDatasView.h"

@interface WeightNoDatasView()

@property (weak, nonatomic) IBOutlet UILabel *flagOne;
@property (weak, nonatomic) IBOutlet UILabel *flagTwo;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UIButton *putInPalletBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *palletBtnLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payBtnRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *palletBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *palletBtnHeight;

@end

@implementation WeightNoDatasView

- (void)awakeFromNib
{
    _flagOne.textColor = ALLightTextColor;
    _flagTwo.textColor = ALLightTextColor;
    _putInPalletBtn.backgroundColor = _payBtn.backgroundColor = ALDisAbleColor;
    _palletBtnLeft.constant = _payBtnRight.constant = 42.5*ALScreenScalWidth;
    _palletBtnWidth.constant = 120*ALScreenScalWidth;
    _palletBtnHeight.constant = 55*ALScreenScalWidth;
    
    
    _putInPalletBtn.layer.cornerRadius = _palletBtnHeight.constant/2.0f;
    _putInPalletBtn.layer.masksToBounds = YES;
    
    _payBtn.layer.cornerRadius = _palletBtnHeight.constant/2.0f;
    _payBtn.layer.masksToBounds = YES;
    
}
- (IBAction)btnClick:(id)sender {
    [MBProgressHUD showMessage:@"请先讲果蔬放入托盘中"];
}

+ (instancetype)loadXibView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"WeightNoDatasView" owner:nil options:nil] firstObject];
}


- (void)showAnimate:(BOOL)animate
{

}

- (void)hideAnimate:(BOOL)animate
{
    [UIView animateWithDuration:1.5f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
