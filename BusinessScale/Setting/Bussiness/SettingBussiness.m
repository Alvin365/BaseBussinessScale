//
//  SettingBussiness.m
//  BusinessScale
//
//  Created by Alvin on 16/1/14.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "SettingBussiness.h"
#import "WeightBussiness.h"
#import <Commercial-Bluetooth/CsBtUtil.h>
@implementation SettingBussiness

+ (void)searchGoodsettingList:(void (^)(NSArray *, NSArray *))completedBlock
{
    NSMutableDictionary *sqlDic = [NSMutableDictionary dictionary];
    [sqlDic setObject:@(NO) forKey:@"isDelete"];
    [[GoodsTempList getUsingLKDBHelper]search:[GoodsTempList class] where:sqlDic orderBy:@"number" offset:0 count:0 callback:^(NSMutableArray *array) {
        [sqlDic setObject:@(YES) forKey:@"isDelete"];
        NSArray *arr = [[GoodsTempList getUsingLKDBHelper]search:[GoodsTempList class] where:sqlDic orderBy:@"number" offset:0 count:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completedBlock) {
                completedBlock(array,arr);
            }
        });
    }];
}

+ (void)judgeListHaveThisGoods:(GoodsTempList *)model list:(NSArray *)array completedBlock:(void (^)())comletedBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block BOOL isExistNumber = NO;
        __block BOOL isExistName = NO;
        for (GoodsTempList *temp in array) {
            if (!temp.isDelete) {
                if (model.number == temp.number) {
                    isExistNumber = YES;
                    break;
                }
                if ([model.title isEqualToString:temp.title]) {
                    isExistName = YES;
                    break;
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isExistNumber) {
                [MBProgressHUD showError:@"该编号已存在,请修改编号"];
                return ;
            }
            if (isExistName) {
                [MBProgressHUD showError:@"该商品名已存在,请修改商品名称"];
                return;
            }
            
            if (comletedBlock) {
                comletedBlock();
            }
        });
    });
}

@end
