//
//  ALNavigationController.m
//  showTalence
//
//  Created by Alvin on 15/4/15.
//  Copyright (c) 2015年 Alvin. All rights reserved.
//

#import "ALNavigationController.h"
#import "Common.h"
@interface ALNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation ALNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof (self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
    self.navigationBar.translucent = NO;
    self.canHiddenWhenPush = YES;
}

/**  当第一次使用这个类的时候调用1次*/
+ (void)initialize
{
    // 设置UINavigationBarTheme的主题
    [self setupNavigationBarTheme];
    // 设置UIBarButtonItem的主题
    [self setupBarButtonItemTheme];
}

/**  设置UINavigationBarTheme的主题*/
+ (void)setupNavigationBarTheme
{
    UINavigationBar *appearance = [UINavigationBar appearance];
    
    // 设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    // UITextAttributeFont  --> NSFontAttributeName(iOS7)
    textAttrs[NSFontAttributeName] = ALNavigationTitleFont;
    // UIOffsetZero是结构体, 只要包装成NSValue对象, 才能放进字典\数组中
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowOffset = CGSizeZero;
    textAttrs[NSShadowAttributeName] = shadow;
//    textAttrs[NSShadowAttributeName] = [NSValue valueWithUIOffset:UIOffsetZero];
    [appearance setTitleTextAttributes:textAttrs];
    // 电池兰颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // 导航栏颜色
    UIColor *navigationBarColor = ALNavBarColor;
    [appearance setBarTintColor:navigationBarColor];
}

/**  设置UIBarButtonItem的主题*/
+ (void)setupBarButtonItemTheme
{
    // 通过appearance对象能修改整个项目中所有UIBarButtonItem的样式
    UIBarButtonItem *appearance = [UIBarButtonItem appearance];
    
    /**设置文字属性**/
    // 设置普通状态的文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    
    NSShadow *shadow = [[NSShadow alloc]init];
    shadow.shadowOffset = CGSizeZero;
    textAttrs[NSShadowAttributeName] = shadow;
    
    [appearance setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置高亮状态的文字属性
    NSMutableDictionary *highTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    highTextAttrs[NSForegroundColorAttributeName] = [UIColor redColor];
    [appearance setTitleTextAttributes:highTextAttrs forState:UIControlStateHighlighted];
    
    // 设置不可用状态(disable)的文字属性
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionaryWithDictionary:textAttrs];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [appearance setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
}

- (void)removeLineOfNavigationBar
{
    //去除navigationController中navgationBar中的黑线
    if([self.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }
}

#pragma mark - pushAndPop
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count >= 1 && self.canHiddenWhenPush) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if (self.navigationBarHidden) {
        self.navigationBarHidden = NO;
    }
    return [super popViewControllerAnimated:animated];
}

#pragma mark - Utility Methods -

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
