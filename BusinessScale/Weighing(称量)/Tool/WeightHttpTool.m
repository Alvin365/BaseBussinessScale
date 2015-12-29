//
//  WeightHttpTool.m
//  BusinessScale
//
//  Created by Alvin on 15/12/28.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "WeightHttpTool.h"

@implementation WeightHttpTool

+ (void)uploadSaleRecord:(NSDictionary *)params completedBlock:(void (^)(id result))completedBlock
{
    NSMutableDictionary *mp = [NSMutableDictionary dictionaryWithDictionary:params];
    NSDate *date = [NSDate date];
    [mp setObject:date.timeStempString forKey:@"ts"];
    [self put:[NSString stringWithFormat:@"%@po",TestServerce] params:mp completedBlock:completedBlock];
}

@end
