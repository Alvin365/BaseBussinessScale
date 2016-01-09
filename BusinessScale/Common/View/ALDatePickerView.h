//
//  ALDatePickerView.h
//  showTalence
//
//  Created by iMAC001 on 15/5/5.
//  Copyright (c) 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ALDatePickerView;

@protocol ALDatePickerViewDelegate <NSObject>

- (void)ALDatePickerView:(ALDatePickerView *)view clickBtnWithTag:(NSInteger )tag callBackString:(NSString *)str;

@end

@interface ALDatePickerView : UIView

@property (nonatomic, weak) id<ALDatePickerViewDelegate> delegate;
@property (nonatomic, weak) UILabel *titileLabel;
@property (nonatomic, weak) UIDatePicker *picker;

@property (nonatomic, copy) NSString *dateString;

@property (nonatomic, copy) void(^callBack)(NSDate *date);
- (void)show;

@end
