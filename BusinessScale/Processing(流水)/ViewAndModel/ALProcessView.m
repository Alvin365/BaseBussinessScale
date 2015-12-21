//
//  ALProcessView.m
//  BusinessScale
//
//  Created by Alvin on 15/12/16.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "ALProcessView.h"

@implementation ProcessButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(self.width/2.0f-30, 40, 60, 60);
    self.titleLabel.frame = CGRectMake(0, self.imageView.bottom+15*ALScreenScalWidth, self.width, 20);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end

@implementation ALProcessView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat width = self.width/2.0f;
    CGFloat scale = 320.0f/375.0f;
    CGFloat height = scale*width;
    
    NSArray *arr = @[@"日",@"周",@"月",@"jilu"];
    NSArray *titleArr = @[@"日报表",@"周报表",@"月报表",@"收入记录"];
    for (int i = 0; i<4; i++) {
        if (i/2>=1) {
            y = height;
        }
        if (i%2!=0) {
            x = width;
        }else{
            x = 0;
        }
        ProcessButton *btn = [ProcessButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.frame = CGRectMake(x, y, width, height);
        [btn setImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:arr[i]] forState:UIControlStateHighlighted];
        [self addSubview:btn];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"f8f8f8"] andSize:btn.size] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor] andSize:btn.size] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitleColor:ALTextColor forState:UIControlStateNormal];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
    }
    
    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(width, 0,0.5, 2.0f*height)];
    l.backgroundColor = separateLabelColor;
    [self addSubview:l];
    
    for (int i = 0; i < 2; i++) {
        UILabel *sep = [[UILabel alloc]initWithFrame:CGRectMake(0, (i+1.0f)*height, screenWidth, 0.5)];
        sep.backgroundColor = separateLabelColor;
        [self addSubview:sep];
    }
    self.height = 2*height;
}

- (void)btnClick:(UIButton *)btn
{
    if (self.callBack) {
        self.callBack ((ALProcessViewButtonTag)btn.tag);
    }
}

@end
