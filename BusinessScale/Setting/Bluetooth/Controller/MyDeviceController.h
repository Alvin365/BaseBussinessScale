//
//  MyDeviceController.h
//  btWeigh
//
//  Created by mac on 15/6/2.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface MyDeviceController : BaseViewController

@property (retain, nonatomic) IBOutlet UIView *kUIBoundView;
@property (retain, nonatomic) IBOutlet UIView *kUINoboundView;
@property (weak, nonatomic) IBOutlet UIButton *kUIToKnowOkOk;
@property (weak, nonatomic) IBOutlet UIButton *kUIBoundBtn;
@property (retain, nonatomic) IBOutlet UILabel *kUIUnBound;
@property (retain, nonatomic) IBOutlet UILabel *kUIDeviceInfo;
@property (retain ,nonatomic) IBOutlet UIView *kUILine1;
@property (retain, nonatomic) IBOutlet UIView *kUILine2;
@property (weak, nonatomic) IBOutlet UIView *kUIDeviceInfoBg;

@end
