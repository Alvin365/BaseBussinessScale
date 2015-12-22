//
//  AddPayAccountController.m
//  BusinessScale
//
//  Created by Alvin on 15/12/22.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "AddPayAccountController.h"

@interface AddPayAccountController ()

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameFlag;
@property (weak, nonatomic) IBOutlet ALTextField *nameTextFiled;
@property (weak, nonatomic) IBOutlet UILabel *alipayFlag;
@property (weak, nonatomic) IBOutlet ALTextField *alipayTextField;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *sepT;
@property (weak, nonatomic) IBOutlet UILabel *sepM;
@property (weak, nonatomic) IBOutlet UILabel *sepB;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sepHeight;
@property (nonatomic, assign) BOOL canNext;

@end

@implementation AddPayAccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFromXib];
}

- (void)initFromXib
{
    _tipLabel.textColor = ALLightTextColor;
    _nameFlag.textColor = ALTextColor;
    _alipayFlag.textColor = ALTextColor;
    
    _nameTextFiled.inputField.textColor = ALLightTextColor;
    _nameTextFiled.backgroundColor = [UIColor clearColor];
    _alipayTextField.inputField.textColor = ALLightTextColor;
    _alipayTextField.backgroundColor = [UIColor clearColor];
    
    _sepT.backgroundColor = _sepM.backgroundColor = _sepB.backgroundColor = separateLabelColor;
    _sepHeight.constant = ALSeparaLineHeight;
    
    _nextBtn.backgroundColor = ALDisAbleColor;
    _nextBtn.layer.cornerRadius = 5;
    _nextBtn.layer.masksToBounds = YES;
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:@"UITextFieldTextDidChangeNotification" object:_nameTextFiled.inputField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:@"UITextFieldTextDidChangeNotification" object:_alipayTextField.inputField];
    self.view.backgroundColor = backGroudColor;
    
    self.title = [NSString stringWithFormat:@"添加%@账号",self.payTitle];
    _alipayFlag.text = [NSString stringWithFormat:@"%@账号",self.payTitle];
    _tipLabel.text = [NSString stringWithFormat:@"请输入您绑定的%@账号信息",self.payTitle];
}

- (IBAction)next:(UIButton *)sender
{
    if (!self.canNext) {
        [MBProgressHUD showError:@"请输入姓名和支付宝账号"];
    }
    return;
}

- (void)textChange:(NSNotification *)notice
{
    if (self.nameTextFiled.inputField.text.length && self.alipayTextField.inputField.text.length) {
        self.nextBtn.backgroundColor = ALNavBarColor;
        self.canNext = YES;
    }else{
        self.nextBtn.backgroundColor = ALDisAbleColor;
        self.canNext = NO;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
