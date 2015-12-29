//
//  WeightHttpTool.h
//  BusinessScale
//
//  Created by Alvin on 15/12/28.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "ALBaseHttpTool.h"

@interface WeightHttpTool : ALBaseHttpTool

+ (void)uploadSaleRecord:(NSDictionary *)params completedBlock:(void (^)(id result))completedBlock;

@end
