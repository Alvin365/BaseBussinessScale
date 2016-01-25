//
//  BaseView.h
//  BusinessScale
//
//  Created by Alvin on 16/1/19.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView
{
    MBProgressHUD *_progressHud;
}
@property (nonatomic, strong) MBProgressHUD *progressHud;

/** 处理 服务器返回的数据 取到有用的数据*/
- (void)doDatasFromNet:(NSObject *)resuilt useFulData:(void (^)(NSObject *data ))data;

@end
