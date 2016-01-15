//
//  ChartBussiness.m
//  BusinessScale
//
//  Created by Alvin on 16/1/11.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "ChartBussiness.h"

@implementation ChartBussiness

+ (void)chartDatasBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate completedBlock:(void (^)(NSArray *))block
{
    [[SaleTable getUsingLKDBHelper]search:[SaleTable class] where:[NSString stringWithFormat:@"ts>%.2f and ts<%.2f",beginDate.zeroTime.timeStempString,endDate.dayEndTime.timeStempString] orderBy:nil offset:0 count:1000 callback:^(NSMutableArray *array) {
        NSInteger count = [beginDate distanceInDaysToDate:endDate];
        NSMutableArray *dataArray = [NSMutableArray array];
        for (int i = 0; i<=count; i++) {
            SaleTable *sal = [[SaleTable alloc]init];
            [dataArray addObject:sal];
        }
        for (SaleTable *sal in array) {
            NSDate *date = [NSDate dateWithTimeIntervalInMilliSecondSince1970:sal.ts];
            if (sal.paid_fee!=0) {
                if (!count) return ;
                NSInteger index = [beginDate distanceInDaysToDate:date];
                [dataArray replaceObjectAtIndex:index withObject:sal];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(dataArray);
            }
        });
    }];

}

@end
