//
//  ALSelfDefineDatePickerView.h
//  BusinessScale
//
//  Created by Alvin on 15/12/25.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALProcessView.h"

typedef NS_ENUM(NSInteger, ALSelfDefineDatePickerViewTag){
    ALWeekDatePickerView_canleTag = 0,
    ALWeekDatePickerView_confirmTag
};

@interface ALSelfDefineDatePickerView : UIView

@property (nonatomic, assign) ALProcessViewButtonTag type;
@property (nonatomic, weak) UIPickerView *picker;
@property (nonatomic, copy) void (^callBack) (ALSelfDefineDatePickerViewTag tag);

- (void)showAnimate:(BOOL)animate;

@end
