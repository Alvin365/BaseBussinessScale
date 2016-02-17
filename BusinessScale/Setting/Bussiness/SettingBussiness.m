//
//  SettingBussiness.m
//  BusinessScale
//
//  Created by Alvin on 16/1/14.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "SettingBussiness.h"
#import <Commercial-Bluetooth/CsBtUtil.h>
@implementation SettingBussiness

+ (void)upLoadHistories:(NSArray *)datas
{
    CGFloat totalfee = 0.0f;
    CGFloat payfee = 0.0f;
    NSMutableString *string = [NSMutableString string];
    NSMutableArray *dataArray = [NSMutableArray array];
    NSInteger i = 0;
    for (TransactionData *data in datas) {
        if (data.productId != 0xFFFF) {
            NSMutableDictionary *sqlDic = [NSMutableDictionary dictionary];
            if ([AccountTool account].ID) [sqlDic setObject:[AccountTool account].ID forKey:@"uid"];
            [sqlDic setObject:@"ewww" forKey:@"mac"];
            if ([ScaleTool scale].mac) [sqlDic setObject:[ScaleTool scale].mac forKey:@"mac"];
            [sqlDic setObject:@(data.productId) forKey:@"number"];
            NSArray *array = [[GoodsInfoModel getUsingLKDBHelper]search:[GoodsInfoModel class] where:sqlDic orderBy:nil offset:0 count:0];
            if (array.count) {
                totalfee += data.totalPrice*100;
                GoodsInfoModel *model = array[0];
                NSDictionary *dic = @{@"title": model.title, @"unit_price": @((data.unitPrice/1000.0f*100.0f)), @"unit": @"g", @"quantity":@(data.weight*1000),@"icon":model.icon,@"total_price":@((NSInteger)(data.totalPrice*100.0f)),@"icon":model.icon};
                
                [dataArray addObject:dic];
                if (i<2) {
                    [string appendString:model.title];
                    [string appendString:@" "];
                }
                if (i==datas.count-2) {
                    [string appendString:[NSString stringWithFormat:@"等%i样",(int)(i+1)]];
                }
                i++;
            }
        }else{
            payfee = totalfee-data.totalPrice*100;
            NSDictionary *params = @{@"randid":[NSString radom11BitString],@"ts":@([NSDate date].timeStempString),@"title":string,@"total_fee":@(totalfee),@"paid_fee":@(payfee),@"payment_type":@"cash",@"items": dataArray};
            // 插入数据库
            SaleTable *salT = [[SaleTable alloc]init];
            [salT setValuesForKeysWithDictionary:params];
            NSMutableArray *arr = [NSMutableArray array];
            NSArray *items = params[@"items"];
            NSInteger i = 0;
            CGFloat paids = 0.0f;
            for (NSDictionary *dic in items) {
                SaleItem *item = [[SaleItem alloc]init];
                [item setValuesForKeysWithDictionary:dic];
                [arr addObject:item];
                item.unit = WeightUnit_Gram;
                item.discount = [params[@"paid_fee"] floatValue]/[params[@"total_fee"] floatValue];
                item.paid_price = (item.total_price*item.discount);
                if (i==items.count-1) {
                    item.paid_price = (NSInteger)([params[@"paid_fee"] floatValue] - paids);
                }
                if (!item.ts) {
                    item.ts = [NSDate date].timeStempString;
                }
                paids += item.paid_price;
                i++;
            }
            salT.items = arr;
            [[SaleTable getUsingLKDBHelper] insertToDB:salT callback:nil];
        }
    }
}

@end
