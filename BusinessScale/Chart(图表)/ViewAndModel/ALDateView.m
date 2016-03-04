//
//  DateView.m
//  BusinessScale
//
//  Created by Alvin on 16/1/14.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "ALDateView.h"

@interface ALDateView()




@end

@implementation ALDateView

+ (instancetype)loadXibView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ALDateView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)]];
    _currentSeletedDate = [NSDate getWeekFirstDate:[NSDate date]];
}

- (void)tapClick:(UIGestureRecognizer *)reconizer
{
    CGPoint point = [reconizer locationInView:reconizer.view];
    DateViewDirection tag = point.x>=self.width/2.0f?DateViewDirectionRight:DateViewDirectionLeft;
    
    NSDate *afterSelectDate = nil;
    
    if (self.type == DateViewTypeWeek) {
        afterSelectDate = tag==DateViewDirectionRight?[_currentSeletedDate dateByAddingDays:7]:[_currentSeletedDate dateBySubtractingDays:7];
    }else if(self.type == DateViewTypeMonth){
        afterSelectDate = tag==DateViewDirectionRight?[_currentSeletedDate followMonth]:[_currentSeletedDate formerMonth];
    }else{
        afterSelectDate = tag==DateViewDirectionRight?[NSDate dateWithYear:_currentSeletedDate.year+1 Month:1 Day:1]:[NSDate dateWithYear:_currentSeletedDate.year-1 Month:1 Day:1];
    }
    
    if ([self selectedDateIsLaterThanNow:afterSelectDate]) {
        [MBProgressHUD showMessage:@"没有数据"];
        return;
    }
    if ([self selectedDateIsEarlyThanRegist:afterSelectDate]) {
        [MBProgressHUD showMessage:@"已经是最早数据"];
        return;
    }
    _currentSeletedDate = afterSelectDate;
    if (self.callBack) {
        self.callBack(_currentSeletedDate);
    }
}

- (void)setCurrentSeletedDate:(NSDate *)currentSeletedDate
{
    _currentSeletedDate = currentSeletedDate;
    if (self.type == DateViewTypeWeek) {
        _dateL.text = [NSString stringWithFormat:@"%@~%@",[NSString stringWithFormat:@"%i/%i/%i",(int)[NSDate getWeekFirstDate:_currentSeletedDate].year,(int)[NSDate getWeekFirstDate:_currentSeletedDate].month,(int)[NSDate getWeekFirstDate:_currentSeletedDate].day],[NSString stringWithFormat:@"%i/%i/%i",(int)[NSDate getWeekLastDate:_currentSeletedDate].year,(int)[NSDate getWeekLastDate:_currentSeletedDate].month,(int)[NSDate getWeekLastDate:_currentSeletedDate].day]];
    }else if (self.type == DateViewTypeMonth){
        _dateL.text = [NSString stringWithFormat:@"%i年%i月",(int)_currentSeletedDate.year,(int)_currentSeletedDate.month];
    }else{
        _dateL.text = [NSString stringWithFormat:@"%i年",(int)_currentSeletedDate.year];
    }
}

#pragma mark - 判断是否 晚于 今天
- (BOOL)selectedDateIsLaterThanNow:(NSDate *)date
{
    if (self.type == DateViewTypeWeek) {
        return [self selectedWeekDateIsLaterThanNow:date];
    }else if (self.type == DateViewTypeMonth){
        return [self selectedMonthDateIsLaterThanNow:date];
    }else{
        return [self selectedYearDateIsLaterThanNow:date];
    }
}

- (BOOL)selectedWeekDateIsLaterThanNow:(NSDate *)date
{
    return [[NSDate getWeekFirstDate:date] isLaterThanDate:[NSDate date]];
}

- (BOOL)selectedMonthDateIsLaterThanNow:(NSDate *)date
{
    return [[date firstDayOfCurrentMonth] isLaterThanDate:[NSDate date]];
}

- (BOOL)selectedYearDateIsLaterThanNow:(NSDate *)date
{
    return [[NSDate dateWithYear:date.year Month:1 Day:1] isLaterThanDate:[NSDate date]];
}

#pragma mark - 判断是否 早于注册
- (BOOL)selectedDateIsEarlyThanRegist:(NSDate *)date
{
    if (self.type == DateViewTypeWeek) {
        return [self selectedWeekDateIsEarlyThanRegist:date];
    }else if (self.type == DateViewTypeMonth){
        return [self selectedMonthDateIsEarlyThanRegist:date];
    }else{
        return [self selectedYearDateIsEarlyThanRegist:date];
    }
}

- (BOOL)selectedWeekDateIsEarlyThanRegist:(NSDate *)date
{
    NSDate *registDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:[AccountTool account].register_ts];
   return  [[NSDate getWeekLastDate:date] isEarlierThanDate:registDate]&&(![[NSDate getWeekLastDate:date] isSameWeekAsDate:registDate]);
}

- (BOOL)selectedMonthDateIsEarlyThanRegist:(NSDate *)date
{
    NSDate *registDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:[AccountTool account].register_ts];
    BOOL isEarlyThanRegist = NO;
    isEarlyThanRegist = [date isEarlierThanDate:registDate]&&(![date isSameMonthAsDate:registDate]);
    return isEarlyThanRegist;
}

- (BOOL)selectedYearDateIsEarlyThanRegist:(NSDate *)date
{
    NSDate *registDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:[AccountTool account].register_ts];
    return  [date isEarlierThanDate:registDate]&&(![date isSameYearAsDate:registDate]);
}


@end
