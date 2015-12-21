//
//  palletCell.h
//  BusinessScale
//
//  Created by Alvin on 15/12/16.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface palletCellModel : BaseModel

@property (nonatomic, assign) BOOL isSelected;

@end

@interface palletCell : UITableViewCell

@property (nonatomic, copy) void(^callBack) (palletCell *);
@property (nonatomic, strong) palletCellModel *model;


@end
