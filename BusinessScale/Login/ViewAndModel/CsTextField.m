//
//  CsTextField.m
//  btWeigh
//
//  Created by ChipSea on 15/6/5.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "CsTextField.h"

@implementation CsTextField

-(void)setLeftPadding:(CGFloat)padding {
    _leftPadding = padding;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, _leftPadding, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textRectForBounds:bounds];
}


@end
