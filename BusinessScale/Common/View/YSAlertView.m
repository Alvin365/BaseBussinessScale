//
//  YSAlertView.m
//  Patient
//
//  Created by  杨森 on 15/1/19.
//  Copyright (c) 2015年 Alvin. All rights reserved.
//

#import "YSAlertView.h"

@implementation YSAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles click:(donBlock)block
{
    self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if (self) {
        _block = block;
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_block) {
        _block(buttonIndex);
    }
}
@end
