//
//  RecordHeader.m
//  BusinessScale
//
//  Created by Alvin on 15/12/17.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "RecordHeader.h"

@interface RecordHeader()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceFlag;

@end

@implementation RecordHeader

+ (instancetype)loadXibView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"RecordHeader" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    _dateL.textColor = ALNavBarColor;
    [_leftBtn setTitleColor:ALNavBarColor forState:UIControlStateNormal];
    [_rightBtn setTitleColor:ALNavBarColor forState:UIControlStateNormal];
    _priceFlag.textColor = ALNavBarColor;
    _priceL.textColor = ALNavBarColor;
    _topView.layer.cornerRadius = 20.0f;
    _topView.layer.borderColor = ALNavBarColor.CGColor;
    _topView.layer.borderWidth = 1.0f;
    
    [_topView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)]];
}

- (void)tapClick:(UIGestureRecognizer *)reconizer
{
    CGPoint point = [reconizer locationInView:reconizer.view];
    RecordHeaderTag tag = point.x>=self.width/2.0f?RecordHeaderTag_Right:RecordHeaderTag_Left;
    [self caculateDate:tag];
    if (self.callBack) {
        self.callBack(tag);
    }
}

#pragma mark - caculateMonth
- (void)caculateDate:(RecordHeaderTag)tag
{
    NSString *dateString = [NSString stringWithFormat:@"%@15日",_dateL.text];
    NSDate *date = [NSDate convertDateFromString:dateString];
    NSInteger days = [date numberOfDaysInCurrentMonth];
    if (tag == RecordHeaderTag_Left) {
        date = [date dateBySubtractingDays:days];
    }else{
        date = [date dateByAddingDays:days];
    }
    _dateL.text = [NSString stringWithFormat:@"%i年%i月",(int)date.year,(int)date.month];
}

@end
