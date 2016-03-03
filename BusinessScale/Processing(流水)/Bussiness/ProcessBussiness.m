//
//  ProcessBussiness.m
//  BusinessScale
//
//  Created by Alvin on 16/1/9.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "ProcessBussiness.h"

@implementation ProcessBussiness
/**
 * 按时间查看  type：日、周、月
 */
+ (void)reportFormsAccordingTimeByType:(ALProcessViewButtonTag)type beginDate:(NSDate *)beginDate endDate:(NSDate *)endDate completedBlock:(void (^)(NSArray *,CGFloat,CGFloat))block
{
    [[SaleTable getUsingLKDBHelper]search:[SaleTable class] where:[NSString stringWithFormat:@"ts>'%.f' and ts<'%.f'",beginDate.zeroTime.timeStemp,endDate.dayEndTime.timeStemp] orderBy:@"ts desc" offset:0 count:0 callback:^(NSMutableArray *array) {
        ALLog(@"%@",array);
        CGFloat totalPrice = 0.0f;
        CGFloat payPrice = 0.0f;
        NSMutableArray *dataArray = [NSMutableArray array];
        if (type == ALProcessViewButtonTagDay) { // 天
            for (SaleTable *salT in array) {
                totalPrice += salT.total_fee/100.0f;
                payPrice += salT.paid_fee/100.0f;
            }
            [dataArray addObjectsFromArray:array];
        }else{
            NSDate *flagDate = nil;
            NSInteger i = 0;
            for (SaleTable *salT in array) { // 月与周的数据处理
                NSDate *date = [NSDate dateWithTimeIntervalInMilliSecondSince1970:salT.ts];
                if (![flagDate isTheSameDayWithDate:date]) {
                    flagDate = date;
                    NSMutableArray *arr =[NSMutableArray array];
                    SaleTable *tempSal = array[i];
                    NSInteger temTotal = tempSal.total_fee;
                    NSInteger paidTotal = tempSal.paid_fee;
                    for (SaleTable *sal in array) {
                        if ([flagDate isTheSameDayWithDate:[NSDate dateWithTimeIntervalInMilliSecondSince1970:sal.ts]]) {
                            tempSal.total_fee += sal.total_fee;
                            tempSal.paid_fee += sal.paid_fee;
                            [arr addObjectsFromArray:sal.items];
                        }
                    }
                    tempSal.items = arr;
                    tempSal.total_fee -= temTotal;
                    tempSal.paid_fee -= paidTotal;
                    totalPrice += tempSal.total_fee/100.0f;
                    payPrice += tempSal.paid_fee/100.0f;
                    [dataArray addObject:tempSal];
                }
                i++;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(dataArray,payPrice,totalPrice);
            }
        });
    }];
}

/**
 * 按品类查看  type：日、周、月
 */
+ (void)reportFormsAccordingCategoryByType:(ALProcessViewButtonTag)type beginDate:(NSDate *)beginDate endDate:(NSDate *)endDate completedBlock:(void (^)(NSArray *, CGFloat, CGFloat))block
{
    [[SaleItem getUsingLKDBHelper]search:[SaleItem class] where:[NSString stringWithFormat:@"ts>='%.f' and ts<='%.f'",beginDate.zeroTime.timeStemp,endDate.dayEndTime.timeStemp] orderBy:@"title,ts desc" offset:0 count:0 callback:^(NSMutableArray *array) {
        ALLog(@"%@",array);
        NSMutableArray *dataArray = [NSMutableArray array];
        CGFloat totalPrice = 0.0f;
        CGFloat payPrice = 0.0f;
        NSString *key = nil;
        for (SaleItem *item in array) {
            CGFloat price = item.total_price/100.0f;
            if (![key isEqualToString:item.title]) {
                key = item.title;
                NSMutableArray *arr = [NSMutableArray array];
                for (SaleItem *item in array) {
                    if ([item.title isEqualToString:key]) {
                        [arr addObject:item];
                    }
                }
                [dataArray addObject:arr];
            }
            totalPrice += price;
            payPrice += item.paid_price/100.0f;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(dataArray,payPrice,totalPrice);
            }
        });
    }];
}

/**
 * 收入记录
 */
+ (void)recordDatasWithDate:(NSDate *)date completedBlock:(void (^)(NSArray *dataArray,CGFloat price))block
{
    NSDate *beginDate = date.firstDayOfCurrentMonth;
    NSDate *endDate = [date lastDayOfCurrentMonth];

    ALLog(@"%g",beginDate.zeroTime.timeStemp);
    [[SaleTable getUsingLKDBHelper]search:[SaleTable class] where:[NSString stringWithFormat:@"ts>'%.f' and ts<'%.f'",beginDate.zeroTime.timeStemp,endDate.dayEndTime.timeStemp] orderBy:@"ts desc" offset:0 count:0 callback:^(NSMutableArray *array) {
        ALLog(@"%@",array);
        CGFloat totalPrice = 0.0f;
        CGFloat payPrice = 0.0f;
        NSDate *flagDate = nil;
        NSMutableArray *dataArray = [NSMutableArray array];
        for (SaleTable *salT in array) {
            totalPrice += salT.total_fee/100.0f;
            payPrice += salT.paid_fee/100.0f;
            NSDate *date = [NSDate dateWithTimeIntervalInMilliSecondSince1970:salT.ts];
            if (![flagDate isTheSameDayWithDate:date]) {
                flagDate = date;
                NSMutableArray *arr =[NSMutableArray array];
                for (SaleTable *sal in array) {
                    if ([flagDate isTheSameDayWithDate:[NSDate dateWithTimeIntervalInMilliSecondSince1970:sal.ts]]) {
                        [arr addObject:sal];
                    }
                }
                [dataArray addObject:arr];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(dataArray,payPrice);
            }
        });
    }];
}

@end
