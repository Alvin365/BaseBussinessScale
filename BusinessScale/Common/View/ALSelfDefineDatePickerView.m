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
    NSInteger _weeksSelectedRow;
    NSInteger _yearRow;
    NSInteger _monthRow;
}
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) NSMutableArray *years;
@property (nonatomic, strong) NSMutableArray *month;
@property (nonatomic, strong) NSMutableArray *weekdays;

@property (nonatomic, copy) NSDate *selectedMonth;


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
    picker.showsSelectionIndicator = YES;
    [self addSubview:picker];
    [self addSubview:_titleView];
}

- (void)btnClick:(UIButton *)btn
{
    _selectedMonth = [NSDate dateWithYear:[_years[_yearRow] integerValue] Month:[_month[_monthRow] integerValue] Day:1];
    if (btn.tag == ALWeekDatePickerView_confirmTag) {
        if (self.type == ALProcessViewButtonTagMonth) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(monthPickCallBackDate:)]) {
                [self.delegate monthPickCallBackDate:[NSDate dateWithYear:[_years[_yearRow] integerValue] Month:[_month[_monthRow]integerValue] Day:1]];
                _currentDate = [NSDate dateWithYear:[_years[_yearRow] integerValue] Month:[_month[_monthRow]integerValue] Day:1];
            }
        }else if (self.type == ALProcessViewButtonTagWeek){
            if (self.delegate && [self.delegate respondsToSelector:@selector(weekPickCallBackBeginDate:endDate:)]) {
                NSDate *beginDate = [_selectedMonth beginDateByWeekLevel:_weeksSelectedRow];
                _currentDate = beginDate;
                NSDate *endDate = [_selectedMonth endDateByWeekLevel:_weeksSelectedRow];
                [self.delegate weekPickCallBackBeginDate:beginDate endDate:endDate];
            }
        }
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
#pragma mark -初始化 时间选择器当前选择时间
- (void)initializePickerRow
{
    for (NSInteger i = 0; i<_years.count; i++) {
        if (_currentDate.year == [_years[i] integerValue]) {
            _yearRow = i;
            break;
        }
    }
    for (NSInteger i = 0; i<_month.count; i++) {
        if (_currentDate.month == [_month[i] integerValue]) {
            _monthRow = i;
            break;
        }
    }
    [self.picker selectRow:_yearRow inComponent:0 animated:NO];
    [self.picker selectRow:_monthRow inComponent:1 animated:NO];
//    [self pickerView:self.picker didSelectRow:_yearRow inComponent:0];
//    [self pickerView:self.picker didSelectRow:_monthRow inComponent:1];
    if (self.type == ALProcessViewButtonTagWeek) {
        [self.picker selectRow:_weeksSelectedRow inComponent:2 animated:NO];
        [self caculateselectedMonthWeeks];
    }
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
    label.font = [UIFont systemFontOfSize:18];
//    label.textColor = ALNavBarColor;
    if (!component) {
        _yearRow = row;
    }else if (component == 1){
        _monthRow = row;
    }else{
        _weeksSelectedRow = row;
        return;
    }
    if (self.type == ALProcessViewButtonTagWeek) {
        [self.weekdays removeAllObjects];
        [self caculateselectedMonthWeeks];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;
{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor grayColor];
    NSString *string = nil;
    if (!component) {
        string = self.years[row];
    }else if (component == 1){
        string = self.month[row];
    }else{
        NSArray *arr = self.weekdays[row];
        NSDate *weekFirstDate = [arr firstObject];
        NSDate *weekEndDate = [arr lastObject];
        NSString *weekFirstStr = [NSString stringWithFormat:@"%02d.%02d",(int)weekFirstDate.month,(int)weekFirstDate.day];
        NSString *weekEndStr = [NSString stringWithFormat:@"%02d.%02d",(int)weekEndDate.month,(int)weekEndDate.day];
        string = [NSString stringWithFormat:@"%@~%@",weekFirstStr,weekEndStr];
    }
    label.text = string;
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (self.type == ALProcessViewButtonTagWeek) {
        if (component == 2) {
            return screenWidth*5.f/10.0f;
        }
        return screenWidth*5.0f/20.0f;
    }
    return screenWidth/3.0f;
}

#pragma mark -Caculate monthTotalWeeks
- (void)caculateselectedMonthWeeks
{
    NSDate *weekFirstDate = nil;
    NSDate *weekEndDate = nil;
    _selectedMonth = [NSDate dateWithYear:[_years[_yearRow] integerValue] Month:[_month[_monthRow] integerValue] Day:1];
    NSInteger weeks = [_selectedMonth numberOfWeeksInCurrentMonth];
    for (NSInteger i = 0; i<weeks; i++) {
        weekFirstDate = [_selectedMonth beginDateByWeekLevel:i];
        weekEndDate = [_selectedMonth endDateByWeekLevel:i];
        [self.weekdays addObject:@[weekFirstDate,weekEndDate]];
    }
    [self.picker reloadComponent:2];
    [self.picker selectRow:_weeksSelectedRow inComponent:2 animated:YES];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self pickerView:self.picker didSelectRow:0 inComponent:2];
//    });
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    _currentDate = currentDate;
    _selectedMonth = [NSDate dateWithYear:_currentDate.year Month:_currentDate.month Day:1];
    _weeksSelectedRow = _currentDate.weekLevel;
}

@end
