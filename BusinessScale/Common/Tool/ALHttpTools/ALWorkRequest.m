//
//  ALWorkRequest.m
//  BusinessScale
//
//  Created by Alvin on 15/12/31.
//  Copyright © 2015年 Alvin. All rights reserved.
//
#import "ALWorkRequest.h"
#import <AFNetworking.h>

@interface ALHTTPSessionManager : AFHTTPSessionManager

@end

@implementation ALHTTPSessionManager

+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    static ALHTTPSessionManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[ALHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager setSecurityPolicy:[self customSecurityPolicy]];
        NSMutableSet *contentTypes = [[NSMutableSet alloc] init];
        [contentTypes addObject:@"text/html"];
        [contentTypes addObject:@"text/javascript"];
        [contentTypes addObject:@"application/json"];
        [contentTypes addObject:@"text/json"];
        [contentTypes addObject:@"application/xml"];
        [contentTypes addObject:@"text/xml"];
        [contentTypes addObject:@"application/x-plist"];
        [manager.responseSerializer setAcceptableContentTypes:contentTypes];
    });
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    return manager;
}

+ (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"cs_new" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
//    policyWithPinningMode:AFSSLPinningModePublicKey
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = @[certData];
    
    return securityPolicy;
}

@end

@interface ALWorkRequest()
@property (nonatomic, strong) ALHTTPSessionManager *manager;
@end

@implementation ALWorkRequest

- (void)dealloc
{
    _requestParam = nil;
    _error = nil;
}

- (id)initWithParam:(ALRequestParam *)param {
    
    self.manager = [ALHTTPSessionManager shareManager];
    
    [param.headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [self.manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    NSString *method = [param.method copy];
    NSString *URLString = [[NSURL URLWithString:param.urlString relativeToURL:self.manager.baseURL] absoluteString];
    NSMutableDictionary *parameters = (NSMutableDictionary *)[param param];
    
    NSMutableURLRequest *request = nil;
    
    BOOL hasData = NO;
    
    if (param.postDatas != nil && param.postDatas.allValues != nil && param.postDatas.allValues.count > 0) {
        hasData = YES;
    }
    
    if (hasData) {
        request = [self.manager.requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                              URLString:URLString
                                                                             parameters:parameters
                                                              constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                  NSArray *files = [[param postDatas] allValues];
                                                                  [files enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                                      ALPostData *postData = (ALPostData *)obj;
                                                                      if (postData != nil && [postData isKindOfClass:[ALPostData class]]) {
                                                                          if (postData.fileName) {
                                                                              [formData appendPartWithFileData:postData.data
                                                                                                          name:postData.key
                                                                                                      fileName:postData.fileName
                                                                                                      mimeType:postData.mineType];
                                                                          } else {
                                                                              [formData appendPartWithFormData:postData.data name:postData.key];
                                                                          }
                                                                      }
                                                                  }];
                                                              }
                                                                                  error:nil];
    } else {
        request = [self.manager.requestSerializer requestWithMethod:method
                                                                 URLString:URLString
                                                                parameters:parameters
                                                                     error:nil];
    }
    
    id httpBody = [param httpBody];
    
    if (httpBody) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:httpBody
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
        [request setHTTPBody:data];
    }
    
    [request setTimeoutInterval:param.timeout];
    
    if (self = [super init]) {
        self.request = request;
        _requestParam = param;
    }
    return self;
}

- (void)setReturnBlock:(void(^)(NSURLResponse *response,id responseObject))block
{
    ALLog(@"发起网络请求[%@]：%@", self.request.HTTPMethod, self.request.URL.absoluteString);
    ALLog(@"网络请求参数：%@", self.requestParam.param);
    ALLog(@"网络请求头：%@", self.request.allHTTPHeaderFields);
    if (self.request.HTTPBody != nil) {
        ALLog(@"网络请求Body：%@", [[NSString alloc] initWithData:self.request.HTTPBody encoding:NSUTF8StringEncoding]);
    }
    
    if ([self.requestParam.method isEqualToString:ALHttpGet]) {
        NSURLSessionDownloadTask *downloadTask = [self.manager downloadTaskWithRequest:self.request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            if (!error) {
                if (block) {
                    block(response,filePath);
                }
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ALWorkRequestError" object:error];
            }
            ALLog(@"File downloaded to: %@", filePath);
        }];
        [downloadTask resume];
    }else if ([self.requestParam.method isEqualToString:ALHttpPost]||[self.requestParam.method isEqualToString:ALHttpPut]){
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [self.manager
                      uploadTaskWithStreamedRequest:self.request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (error) {
                              NSLog(@"Error: %@", error);
                          } else {
                              NSLog(@"%@ %@", response, responseObject);
                          }
                      }];
        
        [uploadTask resume];
    }else{
        NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:self.request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
            } else {
                NSLog(@"%@ %@", response, responseObject);
            }
        }];
        [dataTask resume];
    }
}

- (void)setError:(NSError *)error {
    _error = error;
}

@end
