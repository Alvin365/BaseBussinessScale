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
    title.font = [UIFont boldSystemFontOfSize:17];
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(10, 12, 15, 15);
    left.titleLabel.font = [UIFont systemFontOfSize:14];
//    [left setTitle:@"取消" forState:UIControlStateNormal];
    [left setImage:[UIImage imageNamed:@"icon_cancel"] forState:UIControlStateNormal];
    
    [left setTitleColor:ALNavBarColor forState:UIControlStateNormal];
    [left addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    left.tag = DateCanleTag;
    
    UIButton *widthCancle = [UIButton buttonWithType:UIButtonTypeCustom];
    [widthCancle addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    widthCancle.tag = DateCanleTag;
    widthCancle.frame = CGRectMake(0, 0, 40, 40);
    
    UIButton *right=[UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(screenWidth-25, 12, 15, 15);
    [right setImage:[UIImage imageNamed:@"icon_ok"] forState:UIControlStateNormal];
//    [right setTitle:@"确定" forState:UIControlStateNormal];
    [right addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [right setTitleColor:ALNavBarColor forState:UIControlStateNormal];
    right.tag = DateConfirmTag;
    right.titleLabel.font = [UIFont systemFontOfSize:14];
    
    UIButton *widthSave = [UIButton buttonWithType:UIButtonTypeCustom];
    [widthSave addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    widthSave.tag = ALWeekDatePickerView_confirmTag;
    widthSave.frame = CGRectMake(screenWidth-40, 0, 40, 40);

    [titleView addSubview:title];
    [titleView addSubview:left];
    [titleView addSubview:right];
    [titleView addSubview:widthCancle];
    [titleView addSubview:widthSave];
    
    UIDatePicker *picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.height+40, screenWidth, 200*ALScreenScalWidth)];
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
    
//    [self selfDefine];
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
    if (button.tag) {
        if (self.callBack) {
            self.callBack(date);
        }
    }
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
        self.titleView.y = self.height-200*ALScreenScalWidth-40;
        self.picker.y = self.height-200*ALScreenScalWidth;
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

//- (void)selfDefine
//{
//    unsigned int outCount;
//    int i;
//    objc_property_t *pProperty = class_copyPropertyList([UIDatePicker class], &outCount);
//    for (i = outCount -1; i >= 0; i--)
//    {
//        // 循环获取属性的名字   property_getName函数返回一个属性的名称
//        NSString *getPropertyName = [NSString stringWithCString:property_getName(pProperty[i]) encoding:NSUTF8StringEncoding];
//        NSString *getPropertyNameString = [NSString stringWithCString:property_getAttributes(pProperty[i]) encoding:NSUTF8StringEncoding];
//        
//        if ([getPropertyName isEqualToString:@"font"]) {
//            [self.picker setValue:[UIFont systemFontOfSize:18] forKey:@"font"];
//        }
//        
//        if ([getPropertyName isEqualToString:@"dateUnderSelectionBar"]) {
//            UILabel *l = [[UILabel alloc]init];
//            l.textColor = [UIColor blackColor];
//            l.font = [UIFont systemFontOfSize:20];
//            [self.picker setValue:l forKeyPath:@"dateUnderSelectionBar"];
//        }
//        
//    }
//    [self.picker enumerateMethodsWithBlock:^(MJMethod *method, BOOL *stop) {
//        
//    }];
//}

@end
