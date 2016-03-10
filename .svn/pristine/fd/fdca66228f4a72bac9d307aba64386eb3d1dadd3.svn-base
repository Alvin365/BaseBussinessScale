//
//  WeixinAccountCell.h
//  BusinessScale
//
//  Created by Alvin on 16/3/10.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayAccountModel.h"
typedef NS_ENUM(NSInteger, WeixinCellButtonTag) {
    WeixinCellButtonTagAdd = 0,
    WeixinCellButtonTagOperation
};
@interface WeixinAccountCell : UITableViewCell

@property (nonatomic, assign) BOOL isManager;
@property (nonatomic, strong) PayAccountModel *model;
@property (nonatomic, copy) void (^callBack)(WeixinCellButtonTag tag);

@end
