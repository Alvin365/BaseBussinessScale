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
#import <Commercial-Bluetooth/CsBtUtil.h>
@implementation WeightBussiness

+ (void)dealPassivityWithArray:(NSArray *)datas CompletedBlock:(void(^)(NSDictionary *params,CGFloat price))block
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
            NSDictionary *params = @{@"randid":[NSString radom11BitString],@"ts":@([NSDate date].timeStempString),@"title":string,@"total_fee":@(totalfee),@"paid_fee":@(payfee),@"payment_type":@"online",@"items": dataArray};
            if(block){
                block(params, payfee);
            }
        }
    }
}

@end

@implementation WeightBussiness(GoodsList)

- (void)getGoodsListCompletedBlock:(void (^)(NSArray *))block
{
    NSDictionary *localDic = [LocalDataTool getGoodsList];
    NSMutableArray *array = [NSMutableArray array];
    [localDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        GoodsTempList *model = [[GoodsTempList alloc]init];
        [model setValuesForKeysWithDictionary:@{@"title":key,@"icon":obj}];
        [array addObject:model];
    }];
    NSArray *arr = [self sortDataArray:array];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (block) {
            block(arr);
        }
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
