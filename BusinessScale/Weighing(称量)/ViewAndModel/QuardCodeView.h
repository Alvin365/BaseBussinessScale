//
//  QuardCodeView.h
//  BusinessScale
//
//  Created by Alvin on 16/1/26.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuardCodeView : UIView

@property (weak, nonatomic) IBOutlet UILabel *priceL;

+ (instancetype)loadXibView;
- (void)showCodeWithCodeURLs:(NSArray *)array;
- (void)hide;
@end
