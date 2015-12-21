//
//  CALayer+ALAnimation.m
//  BusinessScale
//
//  Created by Alvin on 15/12/20.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "CALayer+ALAnimation.h"

@implementation CALayer (ALAnimation)

- (CABasicAnimation *)layerAnimateZoomIn
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @0.0f;
    scaleAnimation.toValue = @1.0f;
    scaleAnimation.removedOnCompletion = YES;
//    scaleAnimation.autoreverses = YES;
    return scaleAnimation;
}

- (CABasicAnimation *)layerAnimateZoomOut
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @1.0f;
    scaleAnimation.toValue = @0.0f;
    scaleAnimation.removedOnCompletion = YES;
    scaleAnimation.autoreverses = YES;
    return scaleAnimation;
}

- (CABasicAnimation *)layerAnimateRotateRight
{
    CABasicAnimation * tranformAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    tranformAnimation.fromValue = [NSNumber numberWithFloat:4*M_PI];
    tranformAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    tranformAnimation.cumulative = YES;
    tranformAnimation.removedOnCompletion = YES;
//    tranformAnimation.autoreverses = YES;
    return tranformAnimation;
}

- (CABasicAnimation *)layerAnimateRotateLeft
{
    CABasicAnimation * tranformAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    tranformAnimation.fromValue = [NSNumber numberWithFloat:0.f];
    tranformAnimation.toValue = [NSNumber numberWithFloat:4*M_PI];
    tranformAnimation.cumulative = YES;
    tranformAnimation.removedOnCompletion = YES;
//    tranformAnimation.autoreverses = YES;
    return tranformAnimation;
}

#pragma mark - Methods

- (void)layerZoomIn
{
    [self addAnimation:[self layerAnimateZoomIn] forKey:@"zoomIn"];
}

- (void)layerZoomOut
{
    [self addAnimation:[self layerAnimateZoomOut] forKey:@"zoomOut"];
}

- (void)layerRotateLeft
{
    [self addAnimation:[self layerAnimateRotateLeft] forKey:@"rotaLeft"];
}

- (void)layerRotateRight
{
    [self addAnimation:[self layerAnimateRotateLeft] forKey:@"rotaRight"];
}

- (void)layerAnimateZoomInAndRoate
{
    CABasicAnimation *zoomIn = [self layerAnimateZoomIn];
    CABasicAnimation *rota = [self layerAnimateRotateLeft];
    CAAnimationGroup *animaGroup = [[CAAnimationGroup alloc]init];
    animaGroup.animations = @[zoomIn,rota];
    animaGroup.duration = 0.25;
    animaGroup.removedOnCompletion = YES;
//    animaGroup.autoreverses = YES;
    [self addAnimation:animaGroup forKey:@"animaGroup"];
}

- (void )layerAnimateZoomOutAndRoate
{
    CAAnimationGroup *animaGroup = [[CAAnimationGroup alloc]init];
    animaGroup.animations = @[[self layerAnimateZoomOut],[self layerAnimateRotateRight]];
    animaGroup.duration = 0.25;
    animaGroup.removedOnCompletion = YES;
    animaGroup.autoreverses = YES;
    [self addAnimation:animaGroup forKey:@"animaGroup"];
}

@end
