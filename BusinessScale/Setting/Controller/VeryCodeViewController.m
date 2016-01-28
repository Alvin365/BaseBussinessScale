//
//  VeryCodeViewController.m
//  BusinessScale
//
//  Created by Alvin on 15/12/22.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "VeryCodeViewController.h"
#import "NSTimer+Addition.h"
#import "BindingSuccessView.h"
#import "SettingRequestTool.h"
@interface VeryCodeViewController ()
{
    BOOL _canSendCode;
    NSTimer *_timer;
}
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet ALTextField *codeTextField;
@property (weak, nonatomic) IBOutlet UILabel *codeFlag;
@property (weak, nonatomic) IBOutlet UILabel *sepT;
@property (weak, nonatomic) IBOutlet UILabel *sepB;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sepHeight;

@property (nonatomic, strong) BindingSuccessView *succeesView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *veryCodeViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeTextH;

@end

@implementation VeryCodeViewController

- (BindingSuccessView *)succeesView
{
    if (!_succeesView) {
        WS(weakSelf);
        _succeesView = [BindingSuccessView loadXibView];
        _succeesView.frame = [UIScreen mainScreen].bounds;
        _succeesView.callBack = ^{
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        };
    }
    return _succeesView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFromXib];
}

- (void)initFromXib
{
    _tipLabel.textColor = ALLightTextColor;
    _codeFlag.textColor = ALTextColor;
    
    _codeTextField.inputField.textColor = ALLightTextColor;
    _codeTextField.backgroundColor = [UIColor clearColor];
    _codeTextField.inputField.keyboardType = UIKeyboardTypeNumberPad;
    
    _sepT.backgroundColor = _sepB.backgroundColor = separateLabelColor;
    _sepHeight.constant = ALSeparaLineHeight;
    
    _nextBtn.backgroundColor = ALDisAbleColor;
    _nextBtn.layer.cornerRadius = 5;
    _nextBtn.layer.masksToBounds = YES;
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _sendCodeBtn.backgroundColor = ALDisAbleColor;
    _sendCodeBtn.layer.cornerRadius = 25;
    [_sendCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _sendCodeBtn.layer.masksToBounds = YES;
    [_sendCodeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:@"UITextFieldTextDidChangeNotification" object:_codeTextField.inputField];
    self.view.backgroundColor = backGroudColor;
    [self addTimer];
    self.title = @"验证码";
    
    self.veryCodeViewHeight.constant = 70*ALScreenScalWidth;
    self.codeTextH.constant = 50*ALScreenScalWidth;
}

- (void)addTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(freshTimer) userInfo:nil repeats:YES];
}

- (void)btnClick:(UIButton *)btn
{
    if (btn==_nextBtn) {
        [self addPayAccount];
    }else{
        if (btn.tag>1) {
            [MBProgressHUD showMessage:@"验证码已经发送，请稍后"];
            return;
        }
    }
}

#pragma mark - requestURL
- (void)addPayAccount
{
    [self.progressHud show:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (BaseViewController *ctl in self.navigationController.viewControllers) {
        [params addEntriesFromDictionary:ctl.pars];
    }
    [params setValue:self.codeTextField.inputField.text forKey:@"vericode"];
    SettingRequestTool *req = [[SettingRequestTool alloc]initWithParam:[SettingRequestTool addPayAccountWith:params]];
    [req setReturnBlock:^(NSURLSessionTask *task, NSURLResponse *response, id responseObject) {
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                [self.succeesView showAnimate:YES];
                AccountModel *model = [AccountTool account];
                if ([params[@"third_type"] isEqualToString:@"alipay"]) {
                    model.alipayNo = params[@"third_id"];
                }else{
                    model.weichatNo = params[@"third_id"];
                }
                [AccountTool saveAccount:model];
            }
        }];
    }];
}

#pragma mark - helpMethod
- (void)textChange:(NSNotification *)notice
{
    if (self.codeTextField.inputField.text.length ) {
        self.nextBtn.backgroundColor = ALNavBarColor;
    }else{
        self.nextBtn.backgroundColor = ALDisAbleColor;
    }
}

- (void)freshTimer
{
    _sendCodeBtn.tag -= 1;
    [_sendCodeBtn setTitle:[NSString stringWithFormat:@"%lds后重发",(long)_sendCodeBtn.tag] forState:UIControlStateNormal];
//    _sendCodeBtn.titleLabel.text = [NSString stringWithFormat:@"%lds后重发",(long)_sendCodeBtn.tag];
    _sendCodeBtn.backgroundColor = ALDisAbleColor;
    if (_sendCodeBtn.tag == 0) {
        _sendCodeBtn.tag = 1;
        [_timer pauseTimer];
        _sendCodeBtn.backgroundColor = ALNavBarColor;
        [_sendCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
