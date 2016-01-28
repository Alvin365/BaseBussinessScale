//
//  LienceController.m
//  btWeigh
//
//  Created by mac on 15/6/2.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "LienceController.h"

@interface LienceController ()<UIWebViewDelegate>

@end

@implementation LienceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"隐私协议";
    self.view.backgroundColor = backGroudColor;
    [self initAll];
}

#pragma mark - custom functions
#pragma mark 初始化
/// 初始化
-(void)initAll {
    _kUIWeb.delegate = self;
    NSString *urlString = [[NSBundle mainBundle] pathForResource: @"agreement" ofType:@"html"];
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [_kUIWeb loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.progressHud show:YES];
    self.progressHud.labelText = @"加载中...";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.progressHud hide:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}


@end
