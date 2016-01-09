//
//  UIInputTextField.h
//  btWeigh
//
//  Created by mac on 15-1-4.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIInputTextField : UIView

//=======================变量========================
@property(nonatomic,retain) UIImageView *delView;
@property(nonatomic,retain) UITextField *textField;


//=======================函数========================
-(UITextField *)getUITextField;
-(void)setPlaceholder:(NSString *)hint;
-(NSString *)getPlaceholder;
@end
