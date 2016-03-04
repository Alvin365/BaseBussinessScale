//
//  BlueToothBar.h
//  BusinessScale
//
//  Created by Alvin on 16/3/4.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "BaseView.h"
#import <CsBtUtil.h>
@interface BlueToothBar : BaseView

@property (nonatomic, assign) CsScaleState state;
@property (nonatomic, copy) void (^callBack)();


@end
