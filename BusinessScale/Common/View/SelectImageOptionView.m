//
//  SelectImageOptionView.m
//  Patient
//
//  Created by chens on 14-10-21.
//  Copyright (c) 2014年 Alvin. All rights reserved.
//

#import "SelectImageOptionView.h"
#import "UIView+RectRound.h"
@interface SelectImageOptionView(){
    UIButton*cancel;
}
@end

@implementation SelectImageOptionView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildSelf];
    }
    return self;
}
- (void)buildSelf
{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moveFrom)];
    [self addGestureRecognizer:tap];
    
    _getFromCamera = [UIButton buttonWithType:UIButtonTypeCustom];
    _getFromCamera.frame = CGRectMake(10,screenHeight-44*3-15.5, screenWidth-20, 44);
    [_getFromCamera setRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:5];
    _getFromCamera.backgroundColor = [UIColor whiteColor];
    [_getFromCamera setTitle:@"拍照" forState:UIControlStateNormal];
    [_getFromCamera setTitleColor:[UIColor colorWithRed:0 green:133.0/255 blue:1 alpha:1] forState:UIControlStateNormal];
    [_getFromCamera addTarget:self action:@selector(moveFrom) forControlEvents:UIControlEventTouchUpInside];

    
    _selectFromAlbum = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectFromAlbum.frame = CGRectMake(10,screenHeight-44*2-15, screenWidth-20, 44);
    [_selectFromAlbum setRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:5];
    _selectFromAlbum.backgroundColor = [UIColor whiteColor];
    [_selectFromAlbum setTitle:@"从相册中选择" forState:UIControlStateNormal];
    [_selectFromAlbum setTitleColor:[UIColor colorWithRed:0 green:133.0/255 blue:1 alpha:1] forState:UIControlStateNormal];
    [_selectFromAlbum addTarget:self action:@selector(moveFrom) forControlEvents:UIControlEventTouchUpInside];

    
    cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(10, screenHeight-44-5, screenWidth-20, 44);
    cancel.layer.cornerRadius = 3;
    cancel.backgroundColor = [UIColor whiteColor];
    [cancel setTitleColor:[UIColor colorWithRed:0 green:133.0/255 blue:1 alpha:1] forState:UIControlStateNormal];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(moveFrom) forControlEvents:UIControlEventTouchUpInside];
    
    _getFromCamera.frame = CGRectMake(10,screenHeight, screenWidth-20, 44);
    _selectFromAlbum.frame = CGRectMake(10,screenHeight+50, screenWidth-20, 44);
    [_getFromCamera addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    _getFromCamera.tag = selectBtnTagCamera;
    _selectFromAlbum.tag = selectBtnTagAbum;
    [_selectFromAlbum addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cancel.frame=CGRectMake(10, screenHeight+100, screenWidth-20, 44);
    
    [self addSubview:_getFromCamera];
    [self addSubview:_selectFromAlbum];
    [self addSubview:cancel];
}
- (void)moveFrom
{
    [UIView animateWithDuration:0.25 animations:^{
        _getFromCamera.frame = CGRectMake(10,screenHeight, screenWidth-20, 44);
        _selectFromAlbum.frame = CGRectMake(10,screenHeight+50, screenWidth-20, 44);
        cancel.frame = CGRectMake(10, screenHeight+100, screenWidth-20, 44);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)showFromBottom
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    [UIView animateWithDuration:0.25 animations:^{
        _getFromCamera.frame = CGRectMake(10,screenHeight-44*3-15.5, screenWidth-20, 44);
        _selectFromAlbum.frame = CGRectMake(10,screenHeight-44*2-15, screenWidth-20, 44);
        cancel.frame = CGRectMake(10, screenHeight-44-5, screenWidth-20, 44);
    }];
}

- (void)btnClick:(UIButton *)btn
{
    if (self.callBtnBack) {
        self.callBtnBack((selectBtnTag)btn.tag);
    }
}
@end
