//
//  ChartView.h
//  BusinessScale
//
//  Created by Alvin on 16/1/10.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartView : UIView

@property (nonatomic, copy) void(^callBack)(NSDate *date);
+ (instancetype)loadXibView;


@end
