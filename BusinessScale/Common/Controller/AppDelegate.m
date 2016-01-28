//
//  AppDelegate.m
//  BusinessScale
//
//  Created by ChipSea on 15/12/14.
//  Copyright © 2015年 chipsea. All rights reserved.
//

#import "AppDelegate.h"
#import "RootTabViewController.h"
#import "NSObject+MJMember.h"
#import "ALCommonTool.h"
#import "ALWellComeView.h"
#import "LogonController.h"
#import "ALNavigationController.h"
#import "OpenBleController.h"
#import "BoundDeviceController.h"
#import "Reachability.h"
#import <Commercial-Bluetooth/CsBtUtil.h>
#import "SetPinningController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor]; //背景颜色为白色
    [self.window makeKeyAndVisible];
    
    if ([AccountTool account].token.length) {
        RootTabViewController *ctl = [[RootTabViewController alloc]init];
        ALNavigationController *nav = [[ALNavigationController alloc]initWithRootViewController:ctl];
        self.window.rootViewController = nav;
    }else{
        WS(weakSelf);
        if ([ALCommonTool isFirstInstall]) {
            /**
             * 第一次安装 绑定界面后到登录
             */
            BaseViewController *bas = nil;
            if ([CsBtUtil getInstance].state == CsScaleStateClosed) {
                bas = [[OpenBleController alloc]init];
            }else{
                if([CsBtCommon getPin].length){
                    bas = [[BoundDeviceController alloc]init];
                }else{
                    bas = [[SetPinningController alloc]init];
                    ((SetPinningController *)bas).isPush = YES;
                }
            }
            
            ALNavigationController *nav = [[ALNavigationController alloc]initWithRootViewController:bas];
            self.window.rootViewController = nav;
            nav.callBack = ^{
                LogonController *ctl = [[LogonController alloc]init];
                ALNavigationController *nav = [[ALNavigationController alloc]initWithRootViewController:ctl];
                weakSelf.window.rootViewController = nav;
            };
        }else{
            /**
             * 未登录状态下
             */
            LogonController *ctl = [[LogonController alloc]init];
            ALNavigationController *nav = [[ALNavigationController alloc]initWithRootViewController:ctl];
            self.window.rootViewController = nav;
        }
    }
   
    /**
     * 新特性、新版本时显示引导页
     */
    if ([ALCommonTool isNewFeature]) {
        ALWellComeView *wellcom = [[ALWellComeView alloc]init];
        [wellcom show];
        
    }
    ALLog(@"%@",NSHomeDirectory());
//    [[NSObject getUsingLKDBHelper]dropAllTable];
    /**
     * 网络观察
     */
    Reachability *hostReach = [Reachability shareReachAbilty];
    [hostReach startNotifier];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
