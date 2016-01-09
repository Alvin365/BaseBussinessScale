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
    // 先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"cs_new" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    securityPolicy.pinnedCertificates = [NSSet setWithObject:certData];
    
    return securityPolicy;
}

@end

@interface ALWorkRequest()
@property (nonatomic, strong) ALHTTPSessionManager *manager;
@end

@implementation ALWorkRequest

- (void)dealloc
{
    _request = nil;
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

- (void)setReturnBlock:(void(^)(NSURLSessionTask *task,NSURLResponse *response,id responseObject))block
{
    ALLog(@"发起网络请求[%@]：%@", self.request.HTTPMethod, self.request.URL.absoluteString);
    ALLog(@"网络请求参数：%@", self.requestParam.param);
    ALLog(@"网络请求头：%@", self.request.allHTTPHeaderFields);
    if (self.request.HTTPBody != nil) {
        ALLog(@"网络请求Body：%@", [[NSString alloc] initWithData:self.request.HTTPBody encoding:NSUTF8StringEncoding]);
    }
    if (self.requestParam.taskType == ALTaskType_DownLoad) {
        NSURLSessionDownloadTask *downloadTask = [self.manager downloadTaskWithRequest:self.request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            if (!error) {
                if (block) {
                    block(downloadTask,response,filePath);
                }
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ALWorkRequestError" object:error];
            }
            ALLog(@"File downloaded to: %@", filePath);
        }];
        [downloadTask resume];
    }else if (self.requestParam.taskType == ALTaskType_UpLoad){
        NSURLSessionUploadTask *uploadTask;
        uploadTask = [self.manager
                      uploadTaskWithStreamedRequest:self.request
                      progress:^(NSProgress * _Nonnull uploadProgress) {
                          
                      }
                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                          if (!error) {
                              if (block) {
                                  block(uploadTask,response,responseObject);
                              }
                              ALLog(@"URLResponse = %@\nresponseObject = %@",response,responseObject);
                          } else {
                              [[NSNotificationCenter defaultCenter]postNotificationName:@"ALWorkRequestError" object:error];
                          }
                      }];
        
        [uploadTask resume];
    }else{
        NSURLSessionDataTask *dataTask = [self.manager dataTaskWithRequest:self.request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (!error) {
                ALLog(@"URLResponse = %@\nresponseObject = %@",response,responseObject);
                if (block) {
                    block(dataTask,response,responseObject);
                }
            } else {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ALWorkRequestError" object:error];
            }
        }];
        [dataTask resume];
    }
}

- (void)setError:(NSError *)error {
    _error = error;
}

@end
