//
//  BlueToothBussiness.h
//  BusinessScale
//
//  Created by Alvin on 16/3/8.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "BaseBussiness.h"

@interface BlueToothBussiness : BaseBussiness
/**
 * 解绑蓝牙后 商品设置列表同步标识为空
 */
+ (void)removeBoundToBleUpdateSychroLogoCompletedBlock:(void(^)())block;

@end
