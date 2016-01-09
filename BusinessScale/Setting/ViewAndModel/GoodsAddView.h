//
//  GoodsAddView.h
//  BusinessScale
//
//  Created by Alvin on 15/12/19.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface GoodsAddView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet ALTextField *nameTextField;
@property (weak, nonatomic) IBOutlet ALTextField *numberTextField;
@property (weak, nonatomic) IBOutlet ALTextField *priceTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottom;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, copy) void(^callBack)(GoodsAddViewButtonTag );

+ (instancetype)loadXibView;

- (void)showAnimate:(BOOL)animate;

@end
