//
//  NavGestureView.h
//  BusinessScale
//
//  Created by Alvin on 15/12/17.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NavGestureView : UIView

@property (nonatomic, copy) void(^callBack)(NavGestureViewTag tag);

@end
