//
//  BaseViewController.h
//  BusinessScale
//
//  Created by Alvin on 15/12/15.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

/** 添加导航栏右按钮*/
- (void)addNavRightBarBtn:(NSString *)str selectorBlock:(void(^)())block;

@end
