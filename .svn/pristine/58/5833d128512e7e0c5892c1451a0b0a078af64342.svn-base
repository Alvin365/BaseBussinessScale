//
//  GoodsListHttpTool.h
//  BusinessScale
//
//  Created by Alvin on 16/1/19.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "ALWorkRequest.h"

@interface GoodsListHttpTool : ALWorkRequest

/**
 * 覆盖服务器保存的物品表 PUT /inventory
 */

+ (ALRequestParam *)coverCoodsListSeverse:(NSArray *)body;

/**
 * 下载服务器保存的物品表
 */
+ (ALRequestParam *)getGoodsListFromSeverse;

/**
 * 上传图标 PUT /inventory/icon
 */
+ (ALRequestParam *)upLoadWithImage:(UIImage *)image;

@end
