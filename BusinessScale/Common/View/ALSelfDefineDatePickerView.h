//
//  ALSelfDefineDatePickerView.h
//  BusinessScale
//
//  Created by Alvin on 15/12/25.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ALSelfDefineDatePickerView : UIView

@property (nonatomic, assign) ALProcessViewButtonTag type;
@property (nonatomic, weak) UIPickerView *picker;
@property (nonatomic, copy) void (^callBack) (ALSelfDefineDatePickerViewTag tag);

- (void)showAnimate:(BOOL)animate;

@end
