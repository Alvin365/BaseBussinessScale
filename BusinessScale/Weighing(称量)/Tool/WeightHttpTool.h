//
//  WeightHttpTool.h
//  BusinessScale
//
//  Created by Alvin on 15/12/28.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "ALBaseHttpTool.h"

@interface WeightHttpTool : ALBaseHttpTool
/**
 * 上传销售记录
 */
+ (void)uploadSaleRecord:(NSDictionary *)params completedBlock:(void (^)(id result))completedBlock;
/**
 * 批量上传销售记录
 */
+ (void)batchUploadSaleRecords:(NSDictionary *)params completedBlock:(void (^)(id result))completedBlock;
@end
