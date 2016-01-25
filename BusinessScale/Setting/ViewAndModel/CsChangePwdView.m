//
//  CsChangePwdView.m
//  btWeigh
//
//  Created by ChipSea on 15/10/22.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "CsChangePwdView.h"

static CsChangePwdView *changePwdView;
@interface CsChangePwdView() {
    UITextField *focusTf;
}

@property (strong, nonatomic) IBOutlet UIView *kLineView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *kContentHeight;
@property (strong, nonatomic) IBOutlet UIButton *kConfirmBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *kHeadWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *kSpaceLblAndTf;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *kSpaceOldAndNew;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *kSpaceNewAndConfirm;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *kTitleTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *kTitleBottom;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *kTextFieldHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *kSpaceHeadToLine;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *kContentViewCenter;


@end

@implementation CsChangePwdView

- (instancetype)init
{
    self = [super init];
    if (self) {
        int height = [UIScreen mainScreen].bounds.size.height;
        int width = [UIScreen mainScreen].bounds.size.width;
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] firstObject];
        self.frame = CGRectMake(0, 0, width, height);
        
        [_kConfirmBtn setTitle:DPLocalizedString(@"sure", @"确认") forState:UIControlStateNormal];
        _kOldPwdTf.placeholder = DPLocalizedString(@"old_password", @"旧密码");
        _kNewPwdTf.placeholder = DPLocalizedString(@"new_password", @"新密码");
        _kTitleLbl.text = DPLocalizedString(@"change_password", @"修改密码");
        _kConfirmNewPwdTf.placeholder = DPLocalizedString(@"confirm_new_pwd", @"确认新密码");
        _kOldPwdTf.delegate = self;
        _kNewPwdTf.delegate = self;
        _kConfirmNewPwdTf.delegate = self;
        _kHeadImg.image = [UIImage imageNamed:@"role_head_default"];
        
        _kTitleLbl.textColor = Color(0, 0, 0, .7);
        _kPhoneLbl.textColor = Color(0, 0, 0, .8);
        _kLineView.backgroundColor = Color(0, 0, 0, .05);
        _kOldPwdTf.backgroundColor = Color(241, 240, 245,1);
        _kNewPwdTf.backgroundColor = Color(241, 240, 245,1);
        _kConfirmNewPwdTf.backgroundColor = Color(241, 240, 245,1);
        _kConfirmBtn.backgroundColor = ALNavBarColor;
        if ([UIScreen mainScreen].bounds.size.height < 667) {
            if (screenHeight == 480) {
                _kContentHeight.constant = 50;
            } else {
                _kContentHeight.constant = 10;
            }
            
            _kHeadWidth.constant = 70;
            _kHeadImg.layer.cornerRadius = 35;
            _kSpaceLblAndTf.constant = 15;
            _kSpaceOldAndNew.constant = 15;
            _kSpaceNewAndConfirm.constant = 15;
            _kTitleTop.constant = 15;
            _kTitleBottom.constant = 12;
            _kTextFieldHeight.constant = 45;
            _kSpaceHeadToLine.constant = 10;
        }
        
        _kPhoneLbl.text = [NSString localizedStringWithFormat:DPLocalizedString(@"account_tip", @"账号：%@"),[AccountTool account].phone];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

+(CsChangePwdView *)showChangePwdView {
    changePwdView = [[CsChangePwdView alloc] init];
    return changePwdView;
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)hide
{
    [self removeFromSuperview];
}

- (IBAction)closeClick:(id)sender {
    ALLog(@"CsChangePwdView --> closeClick");
    [self hide];
}

/// 开始编辑的事件
- (IBAction)textViewBeginEdit:(id)sender {
    focusTf = (UITextField *)sender;
    int height = [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:5 animations:^{
        if (height <= 667) {
            if (height <= 480) {
                if (_kNewPwdTf == focusTf) { // 4系列
                    _kContentViewCenter.constant =  -60;
                } else if (_kConfirmNewPwdTf == focusTf) {
                    _kContentViewCenter.constant = -120;
                } else {
                    _kContentViewCenter.constant = 0;
                }
            } else if (height <= 568) { // 5系列
                if (_kConfirmNewPwdTf == focusTf) {
                    _kContentViewCenter.constant =  -60;
                } else {
                    _kContentViewCenter.constant = 0;
                }
            } else { // 6系列(非6P系列)
                if (_kConfirmNewPwdTf == focusTf) {
                    _kContentViewCenter.constant =  -30;
                } else {
                    _kContentViewCenter.constant = 0;
                }
            }
        }
    }];
    
}

/// 隐藏键盘
#pragma mark 隐藏键盘
-(IBAction)leaveEditMode:(id)sender {
    ALLog(@"CsChangePwdView -> leaveEditMode");
    [_kOldPwdTf resignFirstResponder];
    [_kNewPwdTf resignFirstResponder];
    [_kConfirmNewPwdTf resignFirstResponder];
}


- (IBAction)confirmClick:(id)sender {
    if (!self.kNewPwdTf.text.length) {
        [MBProgressHUD showError:@"新密码不能为空"];
        return;
    }
    if (![self.kConfirmNewPwdTf.text isEqualToString:self.kNewPwdTf.text]) {
        [MBProgressHUD showError:@"确认密码和新密码不一致"];
        return;
    }
    ALLog(@"CsChangePwdView --> confirmClick");
    [self leaveEditMode:nil];
    if (self.callBack) {
        self.callBack(@{@"oldpwd":self.kOldPwdTf.text,@"newpwd":self.kNewPwdTf.text});
    }
}


#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    
    if (textField == _kOldPwdTf) {
        [_kNewPwdTf becomeFirstResponder];
    } else if(textField == _kNewPwdTf) {
        [_kConfirmNewPwdTf becomeFirstResponder];
    } else {
        [self leaveEditMode:nil];
    }
    return YES;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    _kContentViewCenter.constant = 0;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
