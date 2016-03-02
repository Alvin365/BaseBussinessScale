//
//  LoginBussiness.m
//  BusinessScale
//
//  Created by Alvin on 16/2/19.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "LoginBussiness.h"
#import "LoginHttpTool.h"
#import "GlobalBussiness.h"
#import "GoodsListHttpTool.h"
#import "BLEHttpTool.h"
@implementation LoginBussiness

+ (void)loginWithParams:(NSDictionary *)params completedBlock:(void(^)())block
{
    LoginHttpTool *req = [[LoginHttpTool alloc]initWithParam:[LoginHttpTool loginWithParams:params]];
    [req setReturnBlock:^(NSURLSessionTask *task,NSURLResponse *response, id responseObject) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        __block  AccountModel *model = [[AccountModel alloc]init];
        model.token = httpResponse.allHeaderFields[@"cs-token"];
        model.expirytime = httpResponse.allHeaderFields[@"cs-token-expirytime"];
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                NSNumber *number = ((NSDictionary *)data)[@"id"];
                model.ID = [number stringValue];
                model.phone = ((NSDictionary *)data)[@"phone"];
                model.nickName = ((NSDictionary *)data)[@"nickname"];
                [AccountTool saveAccount:model];
                [self getScaleInfoCompletedBlock:^{
                    if (block) {
                        block();
                    }
                }];
            }
        }];
    }];
}

+ (void)getScaleInfoCompletedBlock:(void(^)())block
{
    BLEHttpTool *req = [[BLEHttpTool alloc]initWithParam:[BLEHttpTool getScaleInfo]];
    [req setReturnBlock:^(NSURLSessionTask *task, NSURLResponse *response, id responseObject) {
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if (data) {
                NSDictionary *dic = (NSDictionary *)data;
                ScaleModel *model = [[ScaleModel alloc]init];
                model.wDecimalPoint = [dic[@"weight_digit"] intValue];
                model.uDecimalPoint = [dic[@"price_digit"] intValue];
                model.mac = [dic[@"scale_mac"] lowercaseString];
                [CsBtCommon setBoundMac:model.mac];
                [CsBtCommon setUnitDecimalPoint:model.uDecimalPoint];
                [CsBtCommon setWeightDecimalPoint:model.wDecimalPoint];
                [ScaleTool saveScale:model];
                if (block) {
                    block();
                }
            }
        }];
    }];
}

+ (void)getGoodsListFromSeverce
{
    GoodsListHttpTool *req = [[GoodsListHttpTool alloc]initWithParam:[GoodsListHttpTool getGoodsListFromSeverse]];
    [req setReturnBlock:^(NSURLSessionTask *task, NSURLResponse *response, id responseObject) {
        [self doDatasFromNet:responseObject useFulData:^(NSObject *data) {
            if ([data isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dataDic = (NSDictionary *)data;
//                if (dataDic.count == 1) {
//                    return;
//                }
                if (dataDic[@"code"]) {
                    return ;
                }
                [[GoodsTempList getUsingLKDBHelper]dropTableWithTableName:@"GoodsTempList"];
                [[GoodsInfoModel getUsingLKDBHelper]dropTableWithTableName:@"GoodsList"];
                
                [dataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSDictionary *obj, BOOL * _Nonnull stop) {
                    GoodsInfoModel *model = [[GoodsInfoModel alloc]init];
                    model.uid = [AccountTool account].ID;
                    model.mac = [ScaleTool scale].mac;
                    [model setValuesForKeysWithDictionary:obj];
                    model.unit = [UnitTool unitFromStringSeverce:obj[@"unit"]];
                    [[GoodsInfoModel getUsingLKDBHelper]insertToDB:model callback:nil];
                    
                    GoodsTempList *tempModel = [[GoodsTempList alloc]init];
                    tempModel.uid = [AccountTool account].ID;
                    tempModel.mac = [ScaleTool scale].mac;
                    [tempModel setValuesForKeysWithDictionary:obj];
                    tempModel.unit = [UnitTool unitFromStringSeverce:obj[@"unit"]];
                    
                    [[GoodsTempList getUsingLKDBHelper]insertToDB:tempModel];
                }];
            }
        }];
    }];
}

@end
