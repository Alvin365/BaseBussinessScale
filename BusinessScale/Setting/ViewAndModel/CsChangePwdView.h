//
//  CsChangePwdView.h
//  btWeigh
//
//  Created by ChipSea on 15/10/22.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CsChangePwdView : UIView <UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UITextField *kOldPwdTf;
@property (strong, nonatomic) IBOutlet UITextField *kNewPwdTf;
@property (strong, nonatomic) IBOutlet UITextField *kConfirmNewPwdTf;
@property (strong, nonatomic) IBOutlet UIImageView *kHeadImg;
@property (strong, nonatomic) IBOutlet UILabel *kTitleLbl;
@property (strong, nonatomic) IBOutlet UILabel *kPhoneLbl;

- (void)show;
- (void)hide;
+(CsChangePwdView *)showChangePwdView;

@property (nonatomic, copy) void(^callBack)(NSDictionary *params);

@end
