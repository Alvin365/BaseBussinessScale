//
//  PaySuccessView.h
//  BusinessScale
//
//  Created by Alvin on 16/2/25.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "BaseView.h"

@interface PaySuccessView : BaseView

+ (instancetype)loadXibView;

- (void)showPrice:(NSString *)prce order:(NSString *)order animate:(BOOL)animate;

@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;

@end
