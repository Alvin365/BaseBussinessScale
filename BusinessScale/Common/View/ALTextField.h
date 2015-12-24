//
//  ALTextField.h
//  BusinessScale
//
//  Created by Alvin on 15/12/22.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ALFieldEditState) {
    ALFieldEditState_Begin = 0,
    ALFieldEditState_Changed,
    ALFieldEditState_End
};

@interface ALTextField : UIView<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *inputField;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, copy) void(^textEditStateBlock) (ALFieldEditState);

@end
