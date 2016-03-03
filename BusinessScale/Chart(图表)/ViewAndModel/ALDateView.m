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
    _currentSeletedDate = [NSDate date];
}

- (void)tapClick:(UIGestureRecognizer *)reconizer
{
    CGPoint point = [reconizer locationInView:reconizer.view];
    DateViewDirection tag = point.x>=self.width/2.0f?DateViewDirectionRight:DateViewDirectionLeft;
    
    NSDate *afterSelectDate = nil;
    
    
//    _dateL.text = [NSString stringWithFormat:@"%@~%@",[NSString stringWithFormat:@"%i/%i/%i",(int)[NSDate getWeekFirstDate:_currentSeletedDate].year,(int)[NSDate getWeekFirstDate:_currentSeletedDate].month,(int)[NSDate getWeekFirstDate:_currentSeletedDate].day],[NSString stringWithFormat:@"%i/%i/%i",(int)[NSDate getWeekLastDate:_currentSeletedDate].year,(int)[NSDate getWeekLastDate:_currentSeletedDate].month,(int)[NSDate getWeekLastDate:_currentSeletedDate].day]];
    
    if (tag == DateViewDirectionLeft) {
        if (self.type == DateViewTypeWeek) {
            afterSelectDate = _currentSeletedDate;
        }else if (self.type == DateViewTypeMonth){
            afterSelectDate = [_currentSeletedDate formerMonth];
        }else{
            afterSelectDate = [NSDate dateWithYear:_currentSeletedDate.year-1 Month:1 Day:1];
        }
    }
    
    NSDate *registDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:[AccountTool account].register_ts];
    BOOL isEarlyThanRegist = NO;
    if ([registDate isLaterThanDate:afterSelectDate]) {
        if (self.type == DateViewTypeWeek) {
            isEarlyThanRegist = ![registDate isSameWeekAsDate:afterSelectDate];
        }else if (self.type == DateViewTypeMonth){
            isEarlyThanRegist = ![registDate isSameMonthAsDate:afterSelectDate];
        }else{
            isEarlyThanRegist = ![registDate isSameYearAsDate:afterSelectDate];
        }
    }
    
    if (isEarlyThanRegist) {
        [MBProgressHUD showMessage:@"已经是最早数据"];
        return;
    }
    
    if (self.callBack) {
        self.callBack(tag);
    }
}

@end
