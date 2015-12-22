//
//  ALTextField.h
//  BusinessScale
//
//  Created by Alvin on 15/12/22.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALTextField : UIView<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *inputField;
@property (nonatomic, assign) CGFloat cornerRadius;

@end
