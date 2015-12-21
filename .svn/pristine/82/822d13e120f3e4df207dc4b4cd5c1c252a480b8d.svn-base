//
//  RecordHeader.h
//  BusinessScale
//
//  Created by Alvin on 15/12/17.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RecordHeaderTag) {
    RecordHeaderTag_Left = 0,
    RecordHeaderTag_Right
};

@interface RecordHeader : UIView

@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (nonatomic, copy) void(^callBack)(RecordHeaderTag tag);


+ (instancetype)loadXibView;

@end
