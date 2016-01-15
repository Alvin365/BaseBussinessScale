//
//  ALNavigationController.h
//  showTalence
//
//  Created by Alvin on 15/4/15.
//  Copyright (c) 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALNavigationController : UINavigationController

@property (nonatomic, copy) void(^callBack)();
@property (nonatomic, assign) BOOL canHiddenWhenPush;
- (void)removeLineOfNavigationBar;

@end
