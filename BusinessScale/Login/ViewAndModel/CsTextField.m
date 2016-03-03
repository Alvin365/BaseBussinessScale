//
//  CsTextField.m
//  btWeigh
//
//  Created by ChipSea on 15/6/5.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "CsTextField.h"
#import "ALKeyBordTool.h"
@interface CsTextField()
@property (nonatomic, strong) ALKeyBordTool *keyBoarTool;
@end

@implementation CsTextField

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    WS(weakSelf);
    _keyBoarTool = [ALKeyBordTool loadXibView];
    _keyBoarTool.frame = CGRectMake(0, 0, screenWidth, 40);
    _keyBoarTool.callBack = ^(NSInteger index){
        [weakSelf endEditing:YES];
    };
    self.inputAccessoryView = _keyBoarTool;
}

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
