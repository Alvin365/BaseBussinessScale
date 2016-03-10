//
//  UIView+RectRound.m
//  Patient
//
//  Created by chens on 14-10-21.
//  Copyright (c) 2014年 chens. All rights reserved.
//

#import "UIView+RectRound.h"

@implementation UIView (RectRound)
- (void)setRoundingCorners:(UIRectCorner)corner cornerRadii:(CGFloat)Radius
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(Radius, Radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}
@end
