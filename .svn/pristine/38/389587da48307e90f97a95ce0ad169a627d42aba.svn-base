//
//  ALWeekDatePickerView.m
//  BusinessScale
//
//  Created by Alvin on 15/12/25.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "ALSelfDefineDatePickerView.h"

@interface ALSelfDefineDatePickerView()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    BOOL _animate;
}
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) NSMutableArray *years;
@property (nonatomic, strong) NSMutableArray *month;
@property (nonatomic, strong) NSMutableArray *weekdays;
//@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) NSString *yearStr;
@property (nonatomic, copy) NSString *monthStr;
@property (nonatomic, copy) NSDate *currentMonth;

@end

@implementation ALSelfDefineDatePickerView

- (NSMutableArray *)years
{
    if (!_years) {
        _years = [NSMutableArray array];
        for (int i = 0; i<200; i++) {
            NSString *string = [NSString stringWithFormat:@"%i年",i+1970];
            [_years addObject:string];
        }
    }
    return _years;
}

- (NSMutableArray *)month
{
    if (!_month) {
        _month = [NSMutableArray array];
        for (int i = 1; i<13; i++) {
            [_month addObject:[NSString stringWithFormat:@"%i月",i]];
        }
    }
    return _month;
}

- (NSMutableArray *)weekdays
{
    if (!_weekdays) {
        _weekdays = [NSMutableArray array];
    }
    return _weekdays;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _backGroundView = [[UIView alloc]initWithFrame:self.bounds];
    _backGroundView.backgroundColor = [UIColor blackColor];
    _backGroundView.alpha = 0.4;
    _backGroundView.tag = ALWeekDatePickerView_canleTag;
    _backGroundView.userInteractionEnabled = YES;
    [_backGroundView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)]];
    [self addSubview:_backGroundView];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2-50, 10, 100, 20)];
    title.text = @"编辑日期";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = ALNavBarColor;
    title.font = [UIFont boldSystemFontOfSize:15];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.tag = ALWeekDatePickerView_canleTag;
    [cancelBtn setImage:[UIImage imageNamed:@"icon_cancel"] forState:UIControlStateNormal];
    [cancelBtn setTitleColor:ALNavBarColor forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(10, 12, 15, 15);
    //
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.tag = ALWeekDatePickerView_confirmTag;
    saveBtn.frame = CGRectMake(screenWidth-25, 12, 15, 15);
    [saveBtn setImage:[UIImage imageNamed:@"icon_ok"] forState:UIControlStateNormal];
    
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height, screenWidth, 40)];
    _titleView.backgroundColor = backGroudColor;
    [_titleView addSubview:title];
    [_titleView addSubview:saveBtn];
    [_titleView addSubview:cancelBtn];
    
    UIPickerView *picker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.height, screenWidth,200*ALScreenScalWidth)];
    picker.backgroundColor = [UIColor whiteColor];
    picker.delegate = self;
    picker.dataSource = self;
    self.picker = picker;
//    picker.showsSelectionIndicator = YES;
    [self addSubview:picker];
    [self addSubview:_titleView];
}

- (void)btnClick:(UIButton *)btn
{
    if (self.callBack) {
        self.callBack((ALSelfDefineDatePickerViewTag)btn.tag);
    }
    [self hide];
}

- (void)tapClick
{
    [self hide];
}

#pragma mark -publicMethods

- (void)showAnimate:(BOOL)animate
{
    [[[[UIApplication sharedApplication]windows]lastObject] addSubview:self];
    _animate = animate;
    [self initializePickerRow];
    void (^block)() = ^{
        _titleView.y = self.height-200*ALScreenScalWidth-40;
        self.picker.y = self.height-200*ALScreenScalWidth;
    };
    if (!animate) {
        block();
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        block();
    }];
}

- (void)initializePickerRow
{
    NSDate *now = [NSDate date];
    NSInteger yearRow = 0;
    NSInteger monthRow = 0;
    for (NSInteger i = 0; i<_years.count; i++) {
        if (now.year == [_years[i] integerValue]) {
            yearRow = i;
            break;
        }
    }
    for (NSInteger i = 0; i<_month.count; i++) {
        if (now.month == [_month[i] integerValue]) {
            monthRow = i;
            break;
        }
    }
    [self.picker selectRow:yearRow inComponent:0 animated:NO];
    [self.picker selectRow:monthRow inComponent:1 animated:NO];
    [self pickerView:self.picker didSelectRow:yearRow inComponent:0];
    [self pickerView:self.picker didSelectRow:monthRow inComponent:1];
}

- (void)hide
{
    void (^block)() = ^{
        _titleView.y = self.height;
        self.picker.y = self.height;
    };
    if (!_animate) {
        block();
        [self removeFromSuperview];
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        block();
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -pickerDele&&DataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.type == ALProcessViewButtonTagMonth) {
        return 2;
    }
    return 3;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (!component) {
        return self.years.count;
    }else if (component == 1){
        return self.month.count;
    }
    return self.weekdays.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
{
    UILabel *label = (UILabel *)[pickerView viewForRow:row forComponent:component];
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = ALNavBarColor;
    if (!component) {
        _yearStr = self.years[row];
    }else if (component == 1){
        _monthStr =  self.month[row];
    }else{
        return;
    }
    if (self.type == ALProcessViewButtonTagWeek) {
        [self.weekdays removeAllObjects];
        [self caculateCurrentMonthWeeks];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;
{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17];
    label.textColor = [UIColor grayColor];
//    label.backgroundColor = [UIColor redColor];
    NSString *string = nil;
    if (!component) {
        string = self.years[row];
    }else if (component == 1){
        string = self.month[row];
    }else{
        string = self.weekdays[row];
    }
    label.text = string;
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (self.type == ALProcessViewButtonTagWeek) {
        if (component == 2) {
            return screenWidth*4.0f/7.0f;
        }
        return screenWidth*3.0f/14.0f;
    }
    return screenWidth/3.0f;
}

#pragma mark -Caculate monthTotalWeeks
- (void)caculateCurrentMonthWeeks
{
    NSDate *weekFirstDate = nil;
    NSDate *weekEndDate = nil;
    _currentMonth = [NSDate dateFromStringYYMMDD:[NSString stringWithFormat:@"%i-%i-1",[_yearStr intValue],[_monthStr intValue]]];
    NSInteger weeks = [_currentMonth numberOfWeeksInCurrentMonth];
    for (NSInteger i = 0; i<weeks; i++) {
        NSString *weekFirstStr = nil;
        NSString *weekEndStr = nil;
        if (!i) {
            weekFirstDate = [NSDate getWeekFirstDate:_currentMonth];
            weekEndDate = [NSDate getWeekLastDate:_currentMonth];
        }else{
            weekFirstDate = [weekFirstDate dateByAddingDays:7];
            weekEndDate = [weekEndDate dateByAddingDays:7];
        }
        weekFirstStr = [NSString stringWithFormat:@"%02d月%02d日",(int)weekFirstDate.month,(int)weekFirstDate.day];
        weekEndStr = [NSString stringWithFormat:@"%02d月%02d日",(int)weekEndDate.month,(int)weekEndDate.day];
        [self.weekdays addObject:[NSString stringWithFormat:@"%@~%@",weekFirstStr,weekEndStr]];
    }
    
    [self.picker reloadComponent:2];
    [self.picker selectRow:0 inComponent:2 animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self pickerView:self.picker didSelectRow:0 inComponent:2];
    });
}

@end
