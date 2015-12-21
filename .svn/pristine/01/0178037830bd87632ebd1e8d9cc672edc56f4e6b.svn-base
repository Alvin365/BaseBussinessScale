//
//  BaseViewController.m
//  BusinessScale
//
//  Created by Alvin on 15/12/15.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (nonatomic, strong) UIView *back;
@property (nonatomic, copy) void(^rightBarBtnBlock)();

@end

@implementation BaseViewController

- (UIView *)back
{
    if (!_back) {
        _back = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 13, 8, 12)];
        imageView.image = [UIImage imageNamed:@"icon_left"];
        [_back addSubview:imageView];
        
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+5, 0, 40, 40)];
        l.textColor = [UIColor whiteColor];
        l.text = @"返回";
        l.font = [UIFont systemFontOfSize:15];
        [_back addSubview:l];
        
        _back.userInteractionEnabled = YES;
        [_back addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTo)]];
    }
    return _back;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.navigationController.viewControllers.count > 1) {
        [self buildBack];
    }
}

- (void)buildBack
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.back];
}

- (void)backTo
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addNavRightBarBtn:(NSString *)str selectorBlock:(void(^)())block
{
    UIImage *img = [UIImage orignImage:str];
    if (img) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:str style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    }
    _rightBarBtnBlock = block;
}

- (void)rightClick
{
    if (_rightBarBtnBlock) {
        _rightBarBtnBlock();
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    ALLog(@"%s",__func__);
}

@end
