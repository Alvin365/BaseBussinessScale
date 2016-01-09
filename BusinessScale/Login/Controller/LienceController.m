//
//  LienceController.m
//  btWeigh
//
//  Created by mac on 15/6/2.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "LienceController.h"

@interface LienceController ()

@end

@implementation LienceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"隐私协议";
    [self initAll];
}

#pragma mark - custom functions
#pragma mark 初始化
/// 初始化
-(void)initAll {
    NSString *urlString = [[NSBundle mainBundle] pathForResource: @"agreement" ofType:@"html"];
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_kUIWeb loadRequest:request];
}

@end
