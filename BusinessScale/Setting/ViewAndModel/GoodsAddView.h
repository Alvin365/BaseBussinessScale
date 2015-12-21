//
//  GoodsAddView.h
//  BusinessScale
//
//  Created by Alvin on 15/12/19.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,GoodsAddViewButtonTag) {
    GoodsAddViewButtonTagCancle = 0,
    GoodsAddViewButtonTagSave,
    GoodsAddViewButtonTagUnitKiloGram,
    GoodsAddViewButtonTagUnit500Gram,
    GoodsAddViewButtonTagUnit50Gram,
    GoodsAddViewButtonTagUnitGram
};

@interface GoodsAddView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottom;

@property (nonatomic, copy) void(^callBack)(GoodsAddViewButtonTag );

+ (instancetype)loadXibView;

- (void)showAnimate:(BOOL)animate;

@end
