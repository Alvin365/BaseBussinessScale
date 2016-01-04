//
//  palletCell.h
//  BusinessScale
//
//  Created by Alvin on 15/12/16.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaleModel.h"
@interface palletCellModel : SaleItem

@property (nonatomic, assign) BOOL isSelected;

@end

@interface palletCell : UITableViewCell

@property (nonatomic, strong) UILabel *sepT;

@property (nonatomic, copy) void(^callBack) (palletCell *);
@property (nonatomic, strong) palletCellModel *model;


@end
