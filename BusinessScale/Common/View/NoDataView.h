//
//  NoDataView.h
//  BusinessScale
//
//  Created by Alvin on 16/2/1.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "BaseView.h"

@interface NoDataView : BaseView

@property (weak, nonatomic) IBOutlet UILabel *noDataL;
+ (instancetype)loadXibView;

@end
