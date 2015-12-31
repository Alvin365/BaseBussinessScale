//
//  WeightHttpTool.h
//  BusinessScale
//
//  Created by Alvin on 15/12/28.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "ALWorkRequest.h"

@interface WeightHttpTool : ALWorkRequest
/**
 * 上传销售记录
 */
+ (ALRequestParam *)uploadSaleRecord:(NSDictionary *)params;
/**
 * 批量上传销售记录
 */
+ (ALRequestParam *)batchUploadSaleRecords:(NSDictionary *)params;
@end
