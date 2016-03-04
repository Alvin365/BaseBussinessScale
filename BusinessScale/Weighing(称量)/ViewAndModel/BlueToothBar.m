//
//  BlueToothBar.m
//  BusinessScale
//
//  Created by Alvin on 16/3/4.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "BlueToothBar.h"

@implementation BlueToothBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.userInteractionEnabled = YES;
    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 70, 20)];
    l.tag = 100;
    l.font = [UIFont systemFontOfSize:14];
    l.textColor = [UIColor whiteColor];
    [self addSubview:l];
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(90, 12.5, 14, 15)];
    imageV.tag = 1000;
    [self addSubview:imageV];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(connectToBlueTooth)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tap];
}

- (void)connectToBlueTooth
{
    if ([ScaleTool scale].mac){
        if ([CsBtUtil getInstance].state == CsScaleStateClosed) {
            [MBProgressHUD showError:@"蓝牙未打开，请开启手机蓝牙"];
        }else if ([CsBtUtil getInstance].state<CsScaleStateConnected) {
            [MBProgressHUD showError:@"请检查秤是否已经激活"];
        }
        return;
    }
    if ([CsBtUtil getInstance].state==CsScaleStateShakeHandSuccess) return;
    if (self.callBack) {
        self.callBack();
    }
}

- (void)setState:(CsScaleState )state
{
    _state = state;
    UILabel *l = [self viewWithTag:100];
    UIImageView *imageV = [self viewWithTag:1000];
    if (state>=CsScaleStateConnected) {
        if ([CsBtUtil getInstance].state!=CsScaleStateShakeHandSuccess) {
            l.text = @"蓝牙连接中";
        }else{
            l.text = @"蓝牙已连接";
        }
        imageV.image = [UIImage imageNamed:@"ble_connected.png"];
    }else if (state == CsScaleStateClosed){
        l.text = @"蓝牙未打开";
        imageV.image = [UIImage imageNamed:@"ble_noconnect.png"];
    }else{
        l.text = @"蓝牙未连接";
        imageV.image = [UIImage imageNamed:@"ble_noconnect.png"];
    }

}

@end
