//
//  ProccessDayHeader.m
//  BusinessScale
//
//  Created by Alvin on 15/12/16.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "ProccessDayHeader.h"

@interface ProccessDayHeader()

@property (weak, nonatomic) IBOutlet UISegmentedControl *segMent;

@end

@implementation ProccessDayHeader

+ (instancetype)loadXibView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ProccessDayHeader" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    self.dateL.textColor = [UIColor whiteColor];
    _totalFlagL.layer.cornerRadius = 12.5f;
    _totalFlagL.layer.masksToBounds = YES;
    _totalFlagL.backgroundColor = [UIColor colorWithHexString:@"608d14"];
    _totalFlagL.textColor = [UIColor colorWithHexString:@"91be46"];
    self.backgroundColor = ALNavBarColor;
    _totalPriceL.textColor = [UIColor whiteColor];

    _segMent.tintColor = [UIColor whiteColor];
    _segMent.backgroundColor = [UIColor clearColor];
    _segMent.layer.cornerRadius = 5;
    _segMent.layer.borderColor = [UIColor whiteColor].CGColor;
    _segMent.layer.borderWidth = 1.0f;
    _segMent.layer.masksToBounds = YES;
    [_segMent setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateSelected];
    [_segMent setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    
//    _date = [NSDate convertDateFromString:_dateL.text];
//    ALLog(@"%@",_date);
}

- (IBAction)segMentselectedIndex:(UISegmentedControl *)sender {
    
}

- (void)setDateTag:(ALProcessViewButtonTag)dateTag
{
    _dateTag = dateTag;
    _date = [NSDate convertDateFromString:_dateL.text];
    ALLog(@"%@",_date);
}



@end
