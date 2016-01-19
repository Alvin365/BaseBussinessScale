//
//  IncomeView.h
//  BusinessScale
//
//  Created by Alvin on 16/1/16.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALInComeView : UIView

+ (instancetype)loadXibIncomeView;

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *priceFlag;
@property (weak, nonatomic) IBOutlet UILabel *priceL;

@end
