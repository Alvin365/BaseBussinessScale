//
//  ChartViewController.m
//  BusinessScaleBase
//
//  Created by Alvin on 15/12/15.
//  Copyright © 2015年 chipsea. All rights reserved.
//

#import "ChartViewController.h"
#import "ChartView.h"
@interface ChartViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ChartView *chartView;

@end

@implementation ChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self buildView];
}

- (void)buildView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -20, screenWidth, screenHeight-49+20)];
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
    _chartView = [ChartView loadXibView];
    _chartView.frame = CGRectMake(0, 0, screenWidth, 548);
    [_scrollView addSubview:_chartView];
    if (_scrollView.height<_chartView.height) {
        _scrollView.contentSize = CGSizeMake(0, _chartView.height+10);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
