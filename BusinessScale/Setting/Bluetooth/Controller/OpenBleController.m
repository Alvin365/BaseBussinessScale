//
//  OpenBleController.m
//  btWeigh
//
//  Created by mac on 15/6/1.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "OpenBleController.h"
#import "BoundDeviceController.h"

@interface OpenBleController ()

@end

@implementation OpenBleController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    isPushing = NO;
    //由于UISwipeGestureRecognizer被iOS7的swipe to pop截取，所以采用UIPanGestureRecognizer来替代滑动事件
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNext:)];
//    [pan setMinimumNumberOfTouches:1];
//    [self.view addGestureRecognizer:pan];
    
    NSString *frmtStr = @"open_ble_1";
    if ([[ALCommonTool getPreferredLanguage] isEqualToString:@"en"]) {
        frmtStr = [frmtStr stringByAppendingString:@"_en"];
    }
    if (screenHeight) {
        frmtStr = [frmtStr stringByAppendingString:@"_4s"];
    }
//    _kUIBackground.image = [UIImage imageNamed:frmtStr];
}

#pragma mark - callback fucntion
#pragma mark 拖动事件的回调函数
///// 拖动事件的回调函数
//-(void)gotoNext:(UIPanGestureRecognizer *)panGestureReconginzer {
//    if (panGestureReconginzer.state == UIGestureRecognizerStateChanged) {
//        CGFloat translation = [panGestureReconginzer translationInView:self.view].x;
//        if (translation<-25 && !isPushing) {
//            ALLog(@"使用Pan模拟的左滑动事件的效果");
//            isPushing = YES;
//            UIViewController *controller = [[BoundDeviceController alloc] init];
//            [self.navigationController pushViewController:controller animated:YES];
//        }
//    }
//}

-(IBAction)gotoNextView:(id)sender {
    UIViewController *controller = [[BoundDeviceController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
