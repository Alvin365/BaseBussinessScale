//
//  ProcessingViewController.m
//  BusinessScaleBase
//
//  Created by Alvin on 15/12/15.
//  Copyright © 2015年 chipsea. All rights reserved.
//

#import "ProcessingViewController.h"
#import "ALProcessView.h"
#import "ProccessDayViewController.h"
#import "ALNavigationController.h"
#import "RecordViewController.h"

@interface ProcessingViewController ()
@property (nonatomic, strong) ALProcessView *process;
@end

@implementation ProcessingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildView];
}

- (void)buildView
{
    WS(weakSelf);
    _process = [[ALProcessView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _process.callBack = ^(ALProcessViewButtonTag tag){
        [weakSelf btnEventWithTag:tag];
    };
    [self.view addSubview:_process];
}

- (void)btnEventWithTag:(ALProcessViewButtonTag )tag
{
    if (tag != ALProcessViewButtonTagRecord) {
        ProccessDayViewController *proDay = [[ProccessDayViewController alloc]init];
        proDay.tag = tag;
        [self.navigationController pushViewController:proDay animated:YES];
    }else{
        RecordViewController *cr = [[RecordViewController alloc]init];
        [self.navigationController pushViewController:cr animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
