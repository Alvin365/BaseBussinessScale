//
//  BoundDeviceController2.h
//  btWeigh
//
//  Created by ChipSea on 15/6/6.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface BoundDeviceController : BaseViewController {
   
}

@property (weak, nonatomic) IBOutlet UIButton *kUINoBound;
@property (retain, nonatomic) IBOutlet UIView *kUISearchedView;
@property (retain, nonatomic) IBOutlet UILabel *kUITip;
@property (retain, nonatomic) IBOutlet UILabel *kUIWeight;
@property (weak, nonatomic) IBOutlet UIButton *kUIResearch;
@property (weak, nonatomic) IBOutlet UIButton *kUISureBound;
@property (weak, nonatomic) IBOutlet UIImageView *kUIBackground;


@end
