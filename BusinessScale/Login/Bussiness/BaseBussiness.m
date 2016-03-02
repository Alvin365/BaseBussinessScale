//
//  BaseBussiness.m
//  BusinessScale
//
//  Created by Alvin on 16/2/19.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "BaseBussiness.h"

@implementation BaseBussiness

+ (void)doDatasFromNet:(NSObject *)resuilt useFulData:(void (^)(NSObject *))data
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"progressHide" object:nil];
    if ([resuilt isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)resuilt;
        if (![dic[@"code"] integerValue]) {
            if (data) {
                if(dic.count==1){
                    data(resuilt);
                }else{
                    data(dic[@"data"]);
                }
            }
        }else{
            [MBProgressHUD showError:dic[@"msg"]];
        }
    }else if ([resuilt isKindOfClass:[NSError class]]){
        NSError *error = (NSError *)resuilt;
        [MBProgressHUD showMessage:error.localizedDescription];
    }else{
        data(nil);
    }
}

@end
