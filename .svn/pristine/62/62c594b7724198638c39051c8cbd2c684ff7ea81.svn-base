//
//  AboutMeViewController.m
//  BusinessScale
//
//  Created by Alvin on 16/3/9.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "AboutMeViewController.h"

@interface AboutMeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *okokLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *banQuanLabel;

@end

@implementation AboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _okokLabel.textColor = ALTextColor;
    _versionLabel.textColor = ALTextColor;
    _banQuanLabel.textColor = ALLightTextColor;
    NSString *ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    _versionLabel.text = [NSString stringWithFormat:@"V %@",ver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
