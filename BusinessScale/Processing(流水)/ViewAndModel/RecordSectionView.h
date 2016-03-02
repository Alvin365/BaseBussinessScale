//
//  RecordSectionView.h
//  BusinessScale
//
//  Created by Alvin on 15/12/18.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordSectionView : UIView

@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *realPrice;
@property (weak, nonatomic) IBOutlet UILabel *cancleLine;

@property (nonatomic, copy) void(^callBack)();

- (void)turnIntoProcessSecctionView;
+ (instancetype)loadXibView;

@end
