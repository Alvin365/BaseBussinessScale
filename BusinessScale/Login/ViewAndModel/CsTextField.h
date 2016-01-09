//
//  CsTextField.h
//  btWeigh
//
//  Created by ChipSea on 15/6/5.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CsTextField : UITextField

@property (assign, nonatomic) IBInspectable CGFloat leftPadding;

-(void)setLeftPadding:(CGFloat)padding;

@end
