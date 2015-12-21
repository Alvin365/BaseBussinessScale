//
//  NavGestureView.h
//  BusinessScale
//
//  Created by Alvin on 15/12/17.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, NavGestureViewTag) {
    NavGestureViewClick_Left = 0,
    NavGestureViewClick_Right
};

@interface NavGestureView : UIView

@property (nonatomic, copy) void(^callBack)(NavGestureViewTag tag);

@end
