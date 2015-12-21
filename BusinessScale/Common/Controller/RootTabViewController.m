//
//  RootTabViewController.m
//  showTalence
//
//  Created by Alvin on 15/4/15.
//  Copyright (c) 2015年 Alvin. All rights reserved.
//

#import "RootTabViewController.h"
#import "WeighingViewController.h"
#import "ProcessingViewController.h"
#import "ChartViewController.h"
#import "SettingViewController.h"
#import "ALNavigationController.h"
#import "Common.h"
@interface RootTabViewController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) WeighingViewController *weighing;
@property (nonatomic, strong) ProcessingViewController *process;
@property (nonatomic, strong) ChartViewController *chart;
@property (nonatomic, strong) SettingViewController *setting;
@property (nonatomic, weak) UIViewController *lastSelectedViewContoller;

@end

@implementation RootTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self addAllChildVcs];
    self.tabBar.translucent = NO;
    /**
     * 设置tabbarItem的背景颜色及其选中颜色
     */
    self.tabBar.barTintColor = [UIColor colorWithHexString:@"4b494f"];
    self.tabBar.selectionIndicatorImage = [UIImage imageWithColor:[UIColor colorWithHexString:@"34323a"] andSize:CGSizeMake(screenWidth/4.0, 49)];
}

- (void)addAllChildVcs
{
    _weighing = [[WeighingViewController alloc] init];
    _process = [[ProcessingViewController alloc]init];
    _chart = [[ChartViewController alloc]init];
    _setting = [[SettingViewController alloc]init];
    
    [self addOneChlildVc:_weighing title:@"称量" imageName:@"icon_1" selectedImageName:@"icon_1"];
    [self addOneChlildVc:_process title:@"流水" imageName:@"icon_2" selectedImageName:@"icon_2"];
    [self addOneChlildVc:_chart title:@"图表" imageName:@"icon_3" selectedImageName:@"icon_3"];
    [self addOneChlildVc:_setting title:@"设定" imageName:@"icon_4" selectedImageName:@"icon_4"];
    
    self.lastSelectedViewContoller = _weighing;
    self.selectedIndex = 0;
}

- (void)addOneChlildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 设置标题
    childVc.title = title;
    
    // 设置图标
    UIImage *orgImage = [UIImage imageNamed:imageName];
    orgImage = [orgImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.image = orgImage;
    
    // 设置tabBarItem的普通文字颜色
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[UITextAttributeTextColor] = [UIColor colorWithHexString:@"b4b3b5"];
    textAttrs[UITextAttributeFont] = [UIFont systemFontOfSize:10];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置tabBarItem的选中文字颜色
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[UITextAttributeTextColor] = [UIColor whiteColor];
    [childVc.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = selectedImage;
    // 添加为tabbar控制器的子控制器
    ALNavigationController *nav = [[ALNavigationController alloc] initWithRootViewController:childVc];

    [self addChildViewController:nav];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UINavigationController *)viewController
{
    
}

- (void)setTabbarBackGroundColor:(UIColor *)color
{
    if ([[UIDevice currentDevice].systemVersion floatValue]>=7.0) {
        self.tabBar.barTintColor = color;
    }
}


@end
