//
//  BaseView.m
//  BusinessScale
//
//  Created by Alvin on 16/1/19.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (MBProgressHUD *)progressHud
{
    if (!_progressHud) {
        _progressHud = [[MBProgressHUD alloc]initWithView:self];
        [self addSubview:_progressHud];
    }
    return _progressHud;
}

- (void)doDatasFromNet:(NSObject *)resuilt useFulData:(void (^)(NSObject *))data
{
    [self.progressHud hide:YES];
    if ([resuilt isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)resuilt;
        if (![dic[@"code"] integerValue]) {
            if (data) {
                if (dic.count==1){
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
