//
//  SetPinningController.m
//  BusinessScale
//
//  Created by Alvin on 16/1/28.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "SetPinningController.h"
#import <Commercial-Bluetooth/CsBtUtil.h>
@interface SetPinningController ()

@property (weak, nonatomic) IBOutlet UILabel *sepT;
@property (weak, nonatomic) IBOutlet UILabel *sepB;

@property (weak, nonatomic) IBOutlet UILabel *flagL;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet ALTextField *pinText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pinViewH;

@end

@implementation SetPinningController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFromXib];
}

- (void)initFromXib
{
    _flagL.textColor = ALTextColor;
    _pinViewH.constant = 70*ALScreenScalWidth;
    _pinText.inputField.text = [CsBtCommon getPin];
    _pinText.inputField.secureTextEntry = YES;
    _pinText.inputField.textColor = ALTextColor;
    _pinText.inputField.placeholder = @"请输入4位PIN码";
    _pinText.inputField.keyboardType = UIKeyboardTypeNumberPad;
    
    _sepT.backgroundColor = separateLabelColor;
    _sepB.backgroundColor = separateLabelColor;
    
    if (_pinText.inputField.text.length) {
        _nextBtn.backgroundColor = ALNavBarColor;
    }else{
        _nextBtn.backgroundColor = ALDisAbleColor;
    }
    
    _nextBtn.layer.cornerRadius = 5;
    _nextBtn.layer.masksToBounds = YES;
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:@"UITextFieldTextDidChangeNotification" object:_pinText.inputField];
    self.view.backgroundColor = backGroudColor;
    self.title = @"电话号码验证";
}

- (IBAction)btnClick:(id)sender {
    if (_pinText.inputField.text.length != 4) {
        [MBProgressHUD showMessage:@"PIN码为4位数字"];
        return;
    }
    
    [CsBtCommon setPin:_pinText.inputField.text];
    if (self.isPush) {
        [self.navigationController pushViewController:[[NSClassFromString(@"BoundDeviceController") alloc]init] animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)textChange:(NSNotification *)notice
{
    if (self.pinText.inputField.text.length) {
        self.nextBtn.backgroundColor = ALNavBarColor;
    }else{
        self.nextBtn.backgroundColor = ALDisAbleColor;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
