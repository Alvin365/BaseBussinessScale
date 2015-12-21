//
//  ProccessDayHeader.h
//  BusinessScale
//
//  Created by Alvin on 15/12/16.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALProcessView.h"
@interface ProccessDayHeader : UIView

@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceL;
@property (weak, nonatomic) IBOutlet UILabel *totalFlagL;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) ALProcessViewButtonTag dateTag;

+ (instancetype)loadXibView;

@end
