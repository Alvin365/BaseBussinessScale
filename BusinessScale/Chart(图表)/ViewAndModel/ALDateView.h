//
//  DateView.h
//  BusinessScale
//
//  Created by Alvin on 16/1/14.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,DateViewDirection){
    DateViewDirectionLeft,
    DateViewDirectionRight
};

typedef NS_ENUM(NSInteger, DateViewType) {
    DateViewTypeWeek = 0,
    DateViewTypeMonth,
    DateViewTypeYear
};

@interface ALDateView : UIView

+ (instancetype)loadXibView;

@property (nonatomic, assign) DateViewType type;
@property (nonatomic, copy) NSDate *currentSeletedDate;

@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (nonatomic, copy) void(^callBack)(DateViewDirection direction);

@end
