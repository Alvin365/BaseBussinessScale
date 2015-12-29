//
//  ALBaseHttpTool.m
//  BusinessScale
//
//  Created by Alvin on 15/12/28.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "ALBaseHttpTool.h"
#import <AFNetworking/AFNetworking.h>
@implementation ALBaseHttpTool

+ (void)get:(NSString *)url params:(NSDictionary *)params completedBlock:(void (^)(id responseObject))completedBlock
{
    ALLog(@"url = %@",url);
    ALLog(@"params = %@",params);
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.securityPolicy.allowInvalidCertificates = YES;
    [mgr setSecurityPolicy:[self customSecurityPolicy]];
    [self formHttpHeader:mgr];
    // 2.发送GET请求
    [mgr GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ALLog(@"result = %@",responseObject);
        if (completedBlock) {
            completedBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completedBlock) {
            completedBlock(error);
        }
    }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params completedBlock:(void (^)(id))completedBlock
{
    ALLog(@"url = %@",url);
    ALLog(@"params = %@",params);
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.securityPolicy.allowInvalidCertificates = YES;
    [mgr.requestSerializer setValue:[AccountTool account].token forHTTPHeaderField:@"cs-token"];
    [mgr setSecurityPolicy:[self customSecurityPolicy]];
    [self formHttpHeader:mgr];
    // 2.发送POST请求
    [mgr POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)task.response;
        if ([res.URL.description hasSuffix:@"account/login"]) {
            AccountModel *account = [AccountTool account];
            account.token = res.allHeaderFields[@"cs-token"];
            account.expirytime = res.allHeaderFields[@"cs-token-expirytime"];
            [AccountTool saveAccount:account];
            ALLog(@"allHeaderFields = %@",res.allHeaderFields);
        }
        ALLog(@"result = %@",responseObject);
        if (completedBlock) {
            completedBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        ALLog(@"error=%@",error.description);
        if (completedBlock) {
            completedBlock(error);
        }
    }];
}

+ (void)put:(NSString *)url params:(NSDictionary *)params completedBlock:(void (^)(id result))completedBlock
{
    ALLog(@"url=%@",url);
    ALLog(@"params=%@",params);
    // 1.获得请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.securityPolicy.allowInvalidCertificates = YES;
    [mgr setSecurityPolicy:[self customSecurityPolicy]];
    [self formHttpHeader:mgr];
    // 2.发送POST请求
    [mgr PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        ALLog(@"result = %@",responseObject);
        if (completedBlock) {
            completedBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error=%@",error.description);
        if (completedBlock) {
            completedBlock(error);
        }
    }];
}
#pragma mark -privateMethod
+ (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"cs_new" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = [NSSet setWithObjects:certData, nil];
    
    return securityPolicy;
}

+ (void)formHttpHeader:(AFHTTPSessionManager *)mgr
{
    if ([AccountTool account].token) {
        mgr.requestSerializer = [AFJSONRequestSerializer serializer];
        [mgr.requestSerializer setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [mgr.requestSerializer setValue:[AccountTool account].token forHTTPHeaderField:@"cs-token"];
    }
}

@end
