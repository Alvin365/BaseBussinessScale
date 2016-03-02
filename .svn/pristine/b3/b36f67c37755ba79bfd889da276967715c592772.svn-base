//
//  GlobalBussiness.m
//  BusinessScale
//
//  Created by Alvin on 16/2/17.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "GlobalBussiness.h"
#import "WeightHttpTool.h"
@implementation GlobalBussiness

+ (instancetype)shareBussiness
{
    static GlobalBussiness *bussiness = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bussiness = [[GlobalBussiness alloc]init];
    });
    return bussiness;
}

- (void)batchUpLoadLocalSaleRecordsCompletedBlock:(void (^)())block
{
    @synchronized(self) {
        NSMutableDictionary *sqlDic = [NSMutableDictionary dictionary];
        if ([AccountTool account].ID) [sqlDic setObject:[AccountTool account].ID forKey:@"uid"];
        [[SaleTable getUsingLKDBHelper]search:[SaleTable class] where:sqlDic orderBy:nil offset:0 count:0 callback:^(NSMutableArray *array) {
            NSMutableArray *dataArray = [NSMutableArray array];
            if (array.count) {
                for (SaleTable *table in array) {
                    if (!table.po_uuid.length) {
                        NSDictionary *dic = [table keyValues];
                        for (NSDictionary *dataDic in dic[@"items"]) {
                            [dataDic setValue:@"g" forKey:@"unit"];
                        }
                        [dataArray addObject:dic];
                    }
                }
                if (!dataArray.count) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (block) {
                            block();
                        }
                    });
                    return ;
                };
                WeightHttpTool *req = [[WeightHttpTool alloc]initWithParam:[WeightHttpTool batchUploadSaleRecords:dataArray]];
                [req setReturnBlock:^(NSURLSessionTask *task, NSURLResponse *response, id responseObject) {
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *dic = (NSDictionary *)responseObject;
                        if (![dic[@"code"] integerValue]) {
                            if ([dic[@"data"] isKindOfClass:[NSArray class]]) {
                                NSInteger i = 0;
                                for (SaleTable *table in array) {
                                    if ([dic[@"data"] count]<i+1) {
                                        return ;
                                    }
                                    if (![[[dic objectForKey:@"data"] objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                                        return;
                                    }
                                    table.po_uuid = [[[dic objectForKey:@"data"] objectAtIndex:i] objectForKey:@"po_uuid"];
                                    [[SaleTable getUsingLKDBHelper]updateToDB:table where:nil];
                                    i++;
                                }
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (block) {
                                        block();
                                    }
                                });
                            }
                        }
                    }
                }];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (block) {
                        block();
                    }
                });
            }
        }];
    }
}

- (void)downLoadSaleRecords
{
    @synchronized(self) {
        NSDate *today = [NSDate date];
        NSDate *yearBefore = [today dateBySubtractingDays:365];
        WeightHttpTool *req = [[WeightHttpTool alloc]initWithParam:[WeightHttpTool downLoadSaleRecordsStartTimeString:yearBefore.timeStemp endTimeString:today.timeStemp]];
        [req setReturnBlock:^(NSURLSessionTask *task, NSURLResponse *response, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSDictionary *resultDic = (NSDictionary *)responseObject;
                    if (![resultDic[@"code"] integerValue]) {
                        if ([resultDic[@"data"] isKindOfClass:[NSArray class]]) {
                            NSArray *resultArray = resultDic[@"data"];
//                            [LKDBHelper clearTableData:[SaleTable class]];
//                            [LKDBHelper clearTableData:[SaleItem class]];
                            NSInteger i = 10;
                            for (NSDictionary *dic in resultArray) {
                                NSMutableArray *items = [[NSMutableArray alloc]init];
                                SaleTable *table = [[SaleTable alloc]init];
                                [table setValuesForKeysWithDictionary:dic];
                                for (NSDictionary *itemDic in dic[@"items"]) {
                                    SaleItem *item = [[SaleItem alloc]init];
                                    [item setValuesForKeysWithDictionary:itemDic];
                                    item.ts = table.ts+i;
                                    [items addObject:item];
                                    item.unit = [UnitTool unitFromStringSeverce:itemDic[@"unit"]];
                                    i+=10;
                                }
                                table.items = items;
                                BOOL b = [[SaleTable getUsingLKDBHelper]insertWhenNotExists:table];
                                if (b) {
                                    ALLog(@"插入数据库成功");
                                }else{
                                    ALLog(@"插入数据库失败");
                                }
                            }
                        }
                    }
                });
            }
        }];
    }
}

@end
