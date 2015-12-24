//
//  BindingSuccessView.m
//  BusinessScale
//
//  Created by Alvin on 15/12/24.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "BindingSuccessView.h"

@interface BindingSuccessView()

{
    BOOL _animate;
}

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *flagLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageTop;


@end

@implementation BindingSuccessView

+ (instancetype)loadXibView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"BindingSuccessView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    _contentView.layer.cornerRadius = 5;
    _contentView.layer.masksToBounds = YES;
    
    _flagLabel.textColor = ALTextColor;
    _sureBtn.layer.cornerRadius = 5;
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.backgroundColor = ALNavBarColor;
    [_sureBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
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
//    if (!_animate) {
        [self removeFromSuperview];
    if (self.callBack) {
        self.callBack();
    }
//        return;
//    }
//    [_contentView.layer layerZoomOut];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self removeFromSuperview];
//    });
}

- (void)btnClick:(UIButton *)btn
{
    [self hide];
}

@end
