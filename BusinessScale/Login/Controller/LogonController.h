//
//  LogonControllerViewController.h
//  btWeigh
//
//  Created by ChipSea on 15/6/5.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface LogonController : BaseViewController

@property (weak, nonatomic) IBOutlet UIButton *kUITourist;
@property (weak, nonatomic) IBOutlet UIButton *kUIRegister;
@property (weak, nonatomic) IBOutlet UIButton *kUILogin;
@property (retain, nonatomic) IBOutlet UILabel *kUILogonTip;
@property (weak, nonatomic) IBOutlet UIButton *kUIAgreementLicense;

@end
