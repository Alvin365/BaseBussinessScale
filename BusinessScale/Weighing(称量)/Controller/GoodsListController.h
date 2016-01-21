//
//  GoodsListController.h
//  BusinessScale
//
//  Created by Alvin on 15/12/18.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "BaseViewController.h"

@interface GoodsListController : BaseViewController

@property (nonatomic, assign) NSNumber *number;
@property (nonatomic, assign) BOOL stopUpLoad;
@property (nonatomic, copy) void(^callBack)(GoodsInfoModel *model);

@end
