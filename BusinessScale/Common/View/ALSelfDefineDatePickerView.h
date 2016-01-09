//
//  ALSelfDefineDatePickerView.h
//  BusinessScale
//
//  Created by Alvin on 15/12/25.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ALSelfDefineDatePickerView;
@protocol ALSelfDefineDatePickerViewDelegate <NSObject>

- (void)monthPickCallBackDate:(NSDate *)date;
- (void)weekPickCallBackBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate;

@end

@interface ALSelfDefineDatePickerView : UIView

@property (nonatomic, assign) ALProcessViewButtonTag type;
@property (nonatomic, weak) UIPickerView *picker;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, weak) id<ALSelfDefineDatePickerViewDelegate> delegate;

- (void)showAnimate:(BOOL)animate;

@end
