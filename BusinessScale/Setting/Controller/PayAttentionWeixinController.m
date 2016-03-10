//
//  PayAttentionWeixinController.m
//  BusinessScale
//
//  Created by Alvin on 16/3/10.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "PayAttentionWeixinController.h"

@interface PayAttentionWeixinController ()

@end

@implementation PayAttentionWeixinController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildView];
    self.title = @"关注提现账户";
}

- (void)buildView
{
    UIScrollView *scro = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-64)];
//    UIImageView *img = [UIImageView alloc]
    UIImage *img = [UIImage imageNamed:@"04-支付账号设置-关注提现账户_02.png"];
    CGFloat scale = img.size.height/img.size.width;
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, scale*screenWidth)];
    [scro addSubview:imgV];
    imgV.image = img;
    scro.contentSize = CGSizeMake(0, imgV.height);
    [self.view addSubview:scro];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
