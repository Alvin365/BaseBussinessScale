//
//  GoodsAddView.h
//  BusinessScale
//
//  Created by Alvin on 15/12/19.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface GoodsAddView : BaseView

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet ALTextField *nameTextField;
@property (weak, nonatomic) IBOutlet ALTextField *numberTextField;
@property (weak, nonatomic) IBOutlet ALTextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITableView *goosList;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottom;
@property (nonatomic, assign) WeightUnit currentUnit;

@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, readonly) NSString *icon;


@property (nonatomic, strong) GoodsTempList *model;
@property (nonatomic, copy) void(^callBack)(GoodsTempList  *model);

+ (instancetype)loadXibView;

- (void)showAnimate:(BOOL)animate;
- (void)hideAnimate:(BOOL)animate;

- (void)initilize;

@end
