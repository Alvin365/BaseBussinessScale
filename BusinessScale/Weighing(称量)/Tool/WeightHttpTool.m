//
//  WeightHttpTool.m
//  BusinessScale
//
//  Created by Alvin on 15/12/28.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "WeightHttpTool.h"

@implementation WeightHttpTool

+ (void)uploadSaleRecord:(id)params completedBlock:(void (^)(id result))completedBlock
{
    [self put:[NSString stringWithFormat:@"%@po",TestServerce] params:params completedBlock:completedBlock];
}

+ (void)batchUploadSaleRecords:(id)params completedBlock:(void (^)(id))completedBlock
{
        [self put:[NSString stringWithFormat:@"%@pobatch",TestServerce] paramsWithData:params completedBlock:completedBlock];
    
}

@end
