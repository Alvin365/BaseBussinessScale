//
//  NavGestureView.m
//  BusinessScale
//
//  Created by Alvin on 15/12/17.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "NavGestureView.h"

@interface NavGestureView()

@property (nonatomic, strong) UITapGestureRecognizer *tapGes;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeLeftGR;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeRightGR;

@end

@implementation NavGestureView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
        self.swipeLeftGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(selectorForSwipeLeftGR:)];
        self.swipeLeftGR.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:self.swipeLeftGR];
        
        self.swipeRightGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(selectorForSwipeRightGR:)];
        self.swipeRightGR.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:self.swipeRightGR];
        
        self.tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:self.tapGes];
    }
    return self;
}

- (void)selectorForSwipeLeftGR:(UISwipeGestureRecognizer *)swipeLeftGR
{
    if (self.callBack) {
        self.callBack (NavGestureViewClick_Right);
    }
}

- (void)selectorForSwipeRightGR:(UISwipeGestureRecognizer *)swipeRightGR
{
    if (self.callBack) {
        self.callBack (NavGestureViewClick_Left);
    }
}

- (void)tap:(UITapGestureRecognizer *)tapGR
{
    CGPoint point = [tapGR locationInView:tapGR.view];
    NavGestureViewTag tag = point.x <= self.width/2.0f?NavGestureViewClick_Left:NavGestureViewClick_Right;
    if (self.callBack) {
        self.callBack (tag);
    }
}

@end
