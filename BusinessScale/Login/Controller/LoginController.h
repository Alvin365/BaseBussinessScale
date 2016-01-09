//
//  LoginViewController.h
//  btWeigh
//
//  Created by mac on 15-1-4.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UIInputTextField.h"

#import "CsTextField.h"

///超时时间
#define     TIME_OUT    60

@interface LoginController : BaseViewController<UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet CsTextField *kUIPassword;
@property (retain, nonatomic) IBOutlet CsTextField *kUIAccount;
@property (weak, nonatomic  ) IBOutlet UIButton    *kUIRegister;
@property (weak, nonatomic  ) IBOutlet UIButton    *kUIGetPwd;
@property (weak, nonatomic  ) IBOutlet UIButton    *kUILogin;
@property (retain, nonatomic) IBOutlet UILabel *kUIThirdTip;
@property (strong, nonatomic) IBOutlet UIView      *kUIView;

@property (nonatomic, copy) void(^LoginSuccess) ();

- (void)loginWithParams:(NSDictionary *)params;

@end
