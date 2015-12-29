//
//  ALDatePickerView.h
//  showTalence
//
//  Created by iMAC001 on 15/5/5.
//  Copyright (c) 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    DateCanleTag,
    DateConfirmTag
}DatebtnTag;

@class ALDatePickerView;

@protocol ALDatePickerViewDelegate <NSObject>

- (void)ALDatePickerView:(ALDatePickerView *)view clickBtnWithTag:(NSInteger )tag callBackString:(NSString *)str;

@end

@interface ALDatePickerView : UIView

@property (nonatomic, weak) id<ALDatePickerViewDelegate> delegate;
@property (nonatomic, weak) UILabel *titileLabel;
@property (nonatomic, weak) UIDatePicker *picker;

@property (nonatomic, copy) NSString *dateString;
- (void)show;

@end
