//
//  RecordCell.h
//  BusinessScale
//
//  Created by Alvin on 15/12/18.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RecordCell : UITableViewCell

@property (nonatomic, strong) GoodsInfoModel *model;

- (void)showTopSeparaLine;


@end
