//
//  SettingViewController.h
//  BusinessScaleBase
//
//  Created by Alvin on 15/12/15.
//  Copyright © 2015年 chipsea. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingViewControllerModel : NSObject

@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *className;

- (instancetype)initWithLabel:(NSString *)label className:(NSString *)className;

@end

@interface SettingViewController : BaseViewController

@end
