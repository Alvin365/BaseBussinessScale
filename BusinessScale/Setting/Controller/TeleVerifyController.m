//
//  TeleVerifyController.m
//  BusinessScale
//
//  Created by Alvin on 15/12/22.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "TeleVerifyController.h"
#import "VeryCodeViewController.h"
@interface TeleVerifyController ()

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *teleFlag;
@property (weak, nonatomic) IBOutlet UILabel *sepB;
@property (weak, nonatomic) IBOutlet UILabel *sepT;
@property (weak, nonatomic) IBOutlet ALTextField *teleField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sepHeight;

@property (weak, nonatomic) IBOutlet UIButton *next;

@end

@implementation TeleVerifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFromXib];
}

- (void)initFromXib
{
    _tipLabel.textColor = ALLightTextColor;
    _teleFlag.textColor = ALTextColor;
    
    _teleField.inputField.textColor = ALLightTextColor;
    _teleField.inputField.keyboardType = UIKeyboardTypeNumberPad;
    _teleField.backgroundColor = [UIColor clearColor];
    
    _sepT.backgroundColor = _sepB.backgroundColor = separateLabelColor;
    _sepHeight.constant = ALSeparaLineHeight;
    
    _next.backgroundColor = ALDisAbleColor;
    _next.layer.cornerRadius = 5;
    _next.layer.masksToBounds = YES;
    [_next setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:@"UITextFieldTextDidChangeNotification" object:_teleField.inputField];
    self.view.backgroundColor = backGroudColor;
    self.title = @"电话号码验证";
}

- (IBAction)next:(UIButton *)sender
{
    if (![ALCommonTool verifyMobilePhone:self.teleField.inputField.text]) {
        [MBProgressHUD showMessage:@"手机号码不正确"];
        return;
    }
    VeryCodeViewController *very = [[VeryCodeViewController alloc]init];
    [self.navigationController pushViewController:very animated:YES];
}

- (void)textChange:(NSNotification *)notice
{
    if (self.teleField.inputField.text.length) {
        self.next.backgroundColor = ALNavBarColor;
    }else{
        self.next.backgroundColor = ALDisAbleColor;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
