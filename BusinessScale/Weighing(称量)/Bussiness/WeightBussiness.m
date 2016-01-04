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
@implementation WeightBussiness

- (void)saveSaleToDb:(SaleTable *)sale
{
    
}

@end

@implementation WeightBussiness(GoodsList)

- (void)getGoodsListCompletedBlock:(void (^)(NSArray *))block
{
    LKDBHelper *help = [BaseModel getUsingLKDBHelper];
    [help search:[GoodsInfoModel class] where:nil orderBy:nil offset:0 count:2000 callback:^(NSMutableArray *array) {
        NSArray *arr = [self sortDataArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(arr);
            }
        });
    }];
    
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
