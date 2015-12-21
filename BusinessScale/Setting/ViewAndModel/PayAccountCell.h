//
//  PayAccountCell.h
//  BusinessScale
//
//  Created by Alvin on 15/12/21.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PayWayType) {
    PayWayTypeAlipay = 0,
    PayWayTypeWechatPay
};

@interface PayAccountCell : UITableViewCell

@property (nonatomic, assign) PayWayType type;
@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, copy) void (^callBack)(BOOL isAdd);


+ (CGFloat)cellHeightForIsAdd:(BOOL)isadd;
@end
