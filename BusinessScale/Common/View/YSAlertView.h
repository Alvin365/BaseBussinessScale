//
//  YSAlertView.h
//  Patient
//
//  Created by  杨森 on 15/1/19.
//  Copyright (c) 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^donBlock) (NSInteger index);

@interface YSAlertView : UIAlertView<UIAlertViewDelegate>
@property (nonatomic, copy) donBlock block;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles click:(donBlock)block;

@end
