//
//  PayAccountCell.h
//  BusinessScale
//
//  Created by Alvin on 15/12/21.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayAccountModel.h"
@interface PayAccountCell : UITableViewCell

@property (nonatomic, assign) PayWayType type;

@property (nonatomic, assign) BOOL isManager;
@property (nonatomic, strong) PayAccountModel *model;
@property (nonatomic, copy) void (^callBack)(BOOL isManager);


+ (CGFloat)cellHeightForIsManager:(BOOL)isManager;
@end
