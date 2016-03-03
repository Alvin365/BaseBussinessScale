//
//  ALTextField.m
//  BusinessScale
//
//  Created by Alvin on 15/12/22.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "ALTextField.h"
#import "ALKeyBordTool.h"
@interface ALTextField()

@property (nonatomic, strong) ALKeyBordTool *keyBoarTool;

@end

@implementation ALTextField

- (instancetype)init
{
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    WS(weakSelf);
    _inputField = [[UITextField alloc]init];
    _inputField.delegate = self;
    _inputField.backgroundColor = [UIColor clearColor];
    _inputField.returnKeyType = UIReturnKeyDone;
    _keyBoarTool = [ALKeyBordTool loadXibView];
    _keyBoarTool.frame = CGRectMake(0, 0, screenWidth, 40);
    _keyBoarTool.callBack = ^(NSInteger index){
        [weakSelf endEditing:YES];
    };
    _inputField.inputAccessoryView = _keyBoarTool;
    [_inputField addTarget:self action:@selector(textBeginEdit) forControlEvents:UIControlEventEditingDidBegin];
    [_inputField addTarget:self action:@selector(textEndEdit) forControlEvents:UIControlEventEditingDidEnd];
    [self addSubview:_inputField];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:_inputField];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _inputField.frame = CGRectMake(10, 5, self.width-20, self.height-10);
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

#pragma mark-UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([NSString stringContainsEmoji:string]) {
        [MBProgressHUD showError:@"非法字符"];
        return NO;
    }
    return YES;
}
#pragma mark -textFieldEvent
- (void)textBeginEdit
{
    if (self.textEditStateBlock) {
        self.textEditStateBlock(ALFieldEditState_Begin);
    }
}

- (void)textEndEdit
{
    if (self.textEditStateBlock) {
        self.textEditStateBlock(ALFieldEditState_End);
    }
}

- (void)textChanged:(NSNotification *)notice
{
    UITextField *textField = notice.object;
    if (self.textChanged) {
        self.textChanged(textField.text);
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
