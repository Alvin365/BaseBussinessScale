//
//  BaseViewController.h
//  BusinessScale
//
//  Created by Alvin on 15/12/15.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface BaseViewController : UIViewController
{
    MBProgressHUD *_progressHud;
}
@property (nonatomic, strong) MBProgressHUD *progressHud;

/**
 * 去除navigationController中navgationBar中的黑线
 */
- (void)removeLineOfNavigationBar;

/** 设置导航栏左按钮*/
- (void)addNavLeftBarBtn:(NSString *)str selectorBlock:(void(^)())block;
/** 添加导航栏右按钮*/
- (void)addNavRightBarBtn:(NSString *)str selectorBlock:(void(^)())block;

/** 处理 服务器返回的数据 取到有用的数据*/
- (void)doDatasFromNet:(NSObject *)resuilt useFulData:(void (^)(NSObject *data ))data;
@end
