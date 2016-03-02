//
//  ALSearchBar.m
//  BusinessScale
//
//  Created by Alvin on 16/2/23.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "ALSearchBar.h"

@implementation ALSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (UIView *subView in self.subviews) {
            self.backgroundColor = [UIColor whiteColor];
            ALLog(@"%@",subView);
            if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [subView removeFromSuperview];
            }
            
            if ([subView isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                UITextField *textField = (UITextField *)subView;
                [textField setBorderStyle:UITextBorderStyleNone];
                textField.background = nil;
                textField.frame = CGRectMake(8, 8, self.bounds.size.width - 2* 8,
                                             self.bounds.size.height - 2* 8);
                textField.layer.cornerRadius = 6;
                
                textField.clipsToBounds = YES;
                textField.backgroundColor = [UIColor whiteColor];
            }
        }
        self.enablesReturnKeyAutomatically = NO;
        self.returnKeyType = UIReturnKeyDefault;
    }
    return self;
}

- (void)setCancelButtonTitle:(NSString *)title
{
    for (UIView *searchbuttons in self.subviews)
    {
        if ([searchbuttons isKindOfClass:[UIButton class]])
        {
            UIButton *cancelButton = (UIButton*)searchbuttons;
            [cancelButton setTitle:title forState:UIControlStateNormal];
            break;
        }
    }
}

@end
