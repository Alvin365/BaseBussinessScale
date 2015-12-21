//
//  ALDatePickerView.m
//  showTalence
//
//  Created by iMAC001 on 15/5/5.
//  Copyright (c) 2015年 Alvin. All rights reserved.
//

#import "ALDatePickerView.h"
@interface ALDatePickerView()

@property (nonatomic, copy) NSString *callBackStr;
@property (nonatomic, weak) UIView *titleView;
@end
@implementation ALDatePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, self.height)];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.4;
    blackView.userInteractionEnabled = YES;
    [blackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    [self addSubview:blackView];
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height, screenWidth, 40)];
    titleView.backgroundColor = backGroudColor;
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2-50, 10, 100, 20)];
    title.text = @"编辑日期";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = ALNavBarColor;
    title.font = [UIFont boldSystemFontOfSize:15];
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(10, 12, 15, 15);
    left.titleLabel.font = [UIFont systemFontOfSize:14];
//    [left setTitle:@"取消" forState:UIControlStateNormal];
    [left setImage:[UIImage imageNamed:@"icon_cancel"] forState:UIControlStateNormal];
    
    [left setTitleColor:ALNavBarColor forState:UIControlStateNormal];
    [left addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    left.tag = DateCanleTag;
    
    UIButton *right=[UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(screenWidth-25, 12, 15, 15);
    [right setImage:[UIImage imageNamed:@"icon_ok"] forState:UIControlStateNormal];
//    [right setTitle:@"确定" forState:UIControlStateNormal];
    [right addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [right setTitleColor:ALNavBarColor forState:UIControlStateNormal];
    right.tag = DateConfirmTag;
    right.titleLabel.font = [UIFont systemFontOfSize:14];
    [titleView addSubview:title];
    [titleView addSubview:left];
    [titleView addSubview:right];
    
    UIDatePicker *picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.height+40, screenWidth, 160*ALScreenScalHeight)];
    picker.backgroundColor = [UIColor whiteColor];
    NSDate *date = [NSDate dateWithTimeInterval:0.0f sinceDate:[NSDate date]];
//    picker.date = date;

    picker.maximumDate = date;
    picker.datePickerMode = UIDatePickerModeDate;
    self.picker = picker;
    [self addSubview:picker];
    [self addSubview:titleView];
    
    self.titileLabel = title;
    self.titleView = titleView;
}

- (void)btnClick:(UIButton *)button
{
    NSDate *date = self.picker.date;
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    self.callBackStr = [format stringFromDate:date];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(ALDatePickerView:clickBtnWithTag:callBackString:)]) {
        [self.delegate ALDatePickerView:self clickBtnWithTag:button.tag callBackString:self.callBackStr];
    }
    [self tap];
}

- (void)show
{
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy年MM月dd"];
//    NSString *birthDay = [AccountTool account].birthday;
    if (_dateString.length) {
        self.picker.date = [format dateFromString:_dateString];
    }
    [[[[UIApplication sharedApplication]windows]lastObject] addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.titleView.y = self.height-160*ALScreenScalHeight-40;
        self.picker.y = self.height-160*ALScreenScalHeight;
    }];
}

- (void)tap
{
    [UIView animateWithDuration:0.25 animations:^{
        self.titleView.y = self.height;
        self.picker.y = self.height+40;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
