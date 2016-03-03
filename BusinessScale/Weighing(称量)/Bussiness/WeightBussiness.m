//
//  WeightBussiness.m
//  BusinessScale
//
//  Created by Alvin on 15/12/29.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "WeightBussiness.h"
#import "GoodsInfoModel.h"
#import "ChineseToPinyin.h"
#import "WeightBussiness.h"
#import <Commercial-Bluetooth/CsBtUtil.h>
@implementation WeightBussiness

+ (void)dealPassivityWithArray:(NSArray *)datas CompletedBlock:(void(^)(NSDictionary *params,CGFloat price))block
{
    NSInteger totalfee = 0;
    NSInteger payfee = 0;
    NSMutableArray *dataArray = [NSMutableArray array];
    for (TransactionData *data in datas) {
        if (data.productId != 0xFFFF) {
            totalfee += (NSInteger)(data.totalPrice*100.0f+0.5);
            NSDictionary *dic = [WeightBussiness blueToothDataTransfer:data];
            SaleItem *item = [[SaleItem alloc]init];
            [item setValuesForKeysWithDictionary:dic];
            [dataArray addObject:item];
        }else{
            payfee = totalfee-(NSInteger)(data.totalPrice*100.0f+0.5);
            if (payfee > totalfee) {
                [MBProgressHUD showMessage:@"折扣价不能大于总价，请修改价格"];
                return;
            }
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[WeightBussiness upLoadDatasTransfer:totalfee payFee:payfee datas:dataArray]];
            [params setObject:@"online" forKey:@"payment_type"];
            if(block){
                block(params, payfee);
            }
        }
    }
}

+ (void)upLoadHistories:(NSArray *)datas
{
    NSInteger totalfee = 0;
    NSInteger payfee = 0;
    NSMutableArray *dataArray = [NSMutableArray array];
    for (TransactionData *data in datas) {
        if (data.productId != 0xFFFF) {
            totalfee += (NSInteger)(data.totalPrice*100.0f+0.5);
            NSDictionary *dic = [WeightBussiness blueToothDataTransfer:data];
            SaleItem *item = [[SaleItem alloc]init];
            [item setValuesForKeysWithDictionary:dic];
            [dataArray addObject:item];
        }else{
            payfee = totalfee-(NSInteger)(data.totalPrice*100.0f+0.5);
            if (payfee > totalfee) {
                [MBProgressHUD showMessage:@"折扣价不能大于总价，请修改价格"];
                return;
            }
            
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[WeightBussiness upLoadDatasTransfer:totalfee payFee:payfee datas:dataArray]];
            [params setObject:@"online" forKey:@"payment_type"];
            
            SaleTable *salT = [[SaleTable alloc]init];
            [salT setValuesForKeysWithDictionary:params];
            NSMutableArray *arr = [NSMutableArray array];
            NSArray *items = params[@"items"];
            for (NSDictionary *dic in items) {
                SaleItem *item = [[SaleItem alloc]init];
                [item setValuesForKeysWithDictionary:dic];
                [arr addObject:item];
                item.unit = WeightUnit_Gram;
            }
            salT.items = arr;
            [[SaleTable getUsingLKDBHelper] insertWhenNotExists:salT callback:nil];
        }
    }
}
+ (NSDictionary *)upLoadDatasTransfer:(NSInteger)totals_fee payFee:(NSInteger)paid_fee datas:(NSArray *)dataArray
{
    if (!dataArray.count) {
        return nil;
    }
    
    NSMutableArray *datas = [NSMutableArray array];
    NSMutableString *string = [NSMutableString string];
    NSInteger i = 0;
    NSInteger paids = 0;
    NSInteger time = 10;
    
    for (SaleItem *item in dataArray) {
        item.unit = WeightUnit_Gram;
        item.discount = paid_fee/(totals_fee*1.0f);
        item.paid_price = (item.total_price*item.discount);
//        if (!item.ts) {
        item.ts = [NSDate date].timeStemp + time;
//        }
        if (i==dataArray.count-1) {
            item.paid_price = (NSInteger)(paid_fee - paids);
        }
        paids += item.paid_price;
        NSDictionary *dic = [item keyValues];
        [dic setValue:@"g" forKey:@"unit"];
        NSNumber *number = dic[@"quantity"];
        [dic setValue:@([number floatValue]) forKey:@"quantity"];
        NSMutableDictionary *muDic = [[NSMutableDictionary alloc]init];
        [muDic addEntriesFromDictionary:dic];
        [muDic removeObjectForKey:@"isSelected"];
        [datas addObject:muDic];
        if (i<2) {
            [string appendString:item.title];
            [string appendString:@" "];
        }
        if (i==dataArray.count-1) {
            [string appendString:[NSString stringWithFormat:@"等%i样",(int)(i+1)]];
        }
        i++;
        time += 10;
    }
    
    NSDictionary *params = @{@"randid":[NSString radom11BitString],@"ts":@([NSDate date].timeStemp),@"title":string,@"total_fee":@(totals_fee),@"paid_fee":@(paid_fee),@"items":datas};
    return params;
}

+ (void)orderInsertToLocalSever:(NSDictionary *)orderDic
{
    SaleTable *salT = [[SaleTable alloc]init];
    [salT setValuesForKeysWithDictionary:orderDic];
    NSMutableArray *arr = [NSMutableArray array];
    NSArray *items = orderDic[@"items"];
    NSInteger i = 10;
    for (NSDictionary *dic in items) {
        SaleItem *item = [[SaleItem alloc]init];
        [item setValuesForKeysWithDictionary:dic];
        [arr addObject:item];
        item.unit = WeightUnit_Gram;
        item.ts = salT.ts+i;
        i += 10;
    }
    salT.items = arr;
    [[SaleTable getUsingLKDBHelper] insertWhenNotExists:salT];
}

+ (NSDictionary *)blueToothDataTransfer:(TransactionData *)data
{
    NSMutableDictionary *sqlDic = [NSMutableDictionary dictionary];
//    if ([AccountTool account].ID) [sqlDic setObject:[AccountTool account].ID forKey:@"uid"];
    [sqlDic setObject:@(data.productId) forKey:@"number"];
    
    NSArray *array = [[GoodsInfoModel getUsingLKDBHelper]search:[GoodsInfoModel class] where:sqlDic orderBy:nil offset:0 count:0];
    GoodsInfoModel *model = nil;
    if (array.count) {
        model = array[0];
    }else{
        model = [[GoodsInfoModel alloc]init];
        model.title = @"其他";
        model.icon = @"fdsafas";
    }
    NSDictionary *dic = @{@"title": model.title, @"unit_price": @((NSInteger)(data.unitPrice*100.0f)), @"unit": @"g", @"quantity":@(data.weight*1000),@"icon":model.icon,@"total_price":@((NSInteger)((data.totalPrice+0.005)*100.0f))};
    return dic;
}

@end

@implementation WeightBussiness(GoodsList)

- (void)getGoodsListCompletedBlock:(void (^)(NSArray *))block category:(BOOL)isCategory
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *localDic = [LocalDataTool getGoodsList];
        NSMutableArray *array = [NSMutableArray array];
        [localDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            GoodsTempList *model = [[GoodsTempList alloc]init];
            [model setValuesForKeysWithDictionary:@{@"title":key,@"icon":obj}];
            [array addObject:model];
        }];
        NSArray *arr = [self sortDataArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isCategory) {
                if (block) {
                    block(arr);
                }
            }else{
                if (block) {
                    block(array);
                }
            }
        });
    });
}

#pragma mark -privateMethod
- (NSMutableArray *)sortDataArray:(NSArray *)dataArray
{
    //建立索引的核心
    UILocalizedIndexedCollation *indexCollation = [UILocalizedIndexedCollation currentCollation];
    
    NSArray *sections = [indexCollation sectionTitles];
    // 返回27，是a－z和＃
    NSInteger highSection = [sections count];
    //tableView 会被分成27个section
    NSMutableArray *sortedArray = [NSMutableArray arrayWithCapacity:highSection];
    for (int i = 0; i <= highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sortedArray addObject:sectionArray];
    }
    
    // 名字分section
    for (GoodsInfoModel *model in dataArray) {
        // getUserName是实现中文拼音检索的核心，见NameIndex类
        NSString *firstLetter = [ChineseToPinyin pinyinFromChineseString:model.title];
        if (firstLetter) {
            NSInteger section = [indexCollation sectionForObject:[firstLetter substringToIndex:1] collationStringSelector:@selector(uppercaseString)];
            
            NSMutableArray *array = [sortedArray objectAtIndex:section];
            [array addObject:model];
        }
    }
    
    // 每个section内的数组排序
    for (int i = 0; i < [sortedArray count]; i++) {
        NSArray *array = [[sortedArray objectAtIndex:i] sortedArrayUsingComparator:^NSComparisonResult(GoodsInfoModel *obj1, GoodsInfoModel *obj2) {
            NSString *firstLetter1 = [ChineseToPinyin pinyinFromChineseString:obj1.title];
            firstLetter1 = [[firstLetter1 substringToIndex:1] uppercaseString];
            
            NSString *firstLetter2 = [ChineseToPinyin pinyinFromChineseString:obj2.title];
            firstLetter2 = [[firstLetter2 substringToIndex:1] uppercaseString];
            
            return [firstLetter1 caseInsensitiveCompare:firstLetter2];
        }];
        
        [sortedArray replaceObjectAtIndex:i withObject:[NSMutableArray arrayWithArray:array]];
    }
    
    return sortedArray;
}
@end
