//
//  ALLogonViewController.m
//  BusinessScale
//
//  Created by Alvin on 16/1/19.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "ALLogonViewController.h"

@interface ALLogonViewController ()

@end

@implementation ALLogonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildBack];
}

- (void)buildBack
{
    [self.view addSubview:self.back];
    self.back.frame = CGRectMake(10, 20, 50, 40);
}

- (void)backTo
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
