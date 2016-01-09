//
//  ResetPwdController.h
//  btWeigh
//
//  Created by mac on 15/6/2.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ResetPwdController : BaseViewController

@property (retain, nonatomic) IBOutlet UITextField *kUIAccount;
@property (retain, nonatomic) IBOutlet UITextField *kUIPassword;
@property (retain, nonatomic) IBOutlet UITextField *kUIConfirmPwd;
@property (retain, nonatomic) IBOutlet UITextField *kUIVCode;
@property (weak ,nonatomic) IBOutlet UIButton *kUIGetVCode;
@property (weak, nonatomic) IBOutlet UIButton *kUIConfirm;
@property (retain, nonatomic) IBOutlet UILabel *kUITimeShow;

@end
