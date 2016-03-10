//
//  DeviceInformationController.h
//  btWeigh
//
//  Created by ChipSea on 15/6/18.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface DeviceInformationController : BaseViewController

@property (retain, nonatomic) IBOutlet UILabel *kUIFirm;
@property (retain, nonatomic) IBOutlet UILabel *kUITel;
@property (weak, nonatomic) IBOutlet UILabel *kUIAddress;
@property (weak, nonatomic) IBOutlet UIImageView *kLogo;

@end
