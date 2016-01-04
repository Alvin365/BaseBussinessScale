//
//  ALRequestParam.h
//  BusinessScale
//
//  Created by Alvin on 15/12/31.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ALAdditions.h"

extern NSString * const ALHttpGet;
extern NSString * const ALHttpPost;
extern NSString * const ALHttpDelete;
extern NSString * const ALHttpPut;
extern NSString * const ALHttpPatch;
extern NSString * const ALHttpHead;

typedef NS_ENUM(NSInteger, ALRequestType) {
    ALRequestTypeOfRemote = 1,
    ALRequestTypeOfLocal,
    ALRequestTypeOfAll
};

@interface ALPostData : NSObject

@property (nonatomic, strong) NSData    *data;
@property (nonatomic, strong) NSString  *key;
@property (nonatomic, strong) NSString  *fileName;
@property (nonatomic, strong) NSString  *mineType;

@end

@interface ALRequestParam : NSObject {
    NSString            *_urlString;
    NSString            *_method;
    NSTimeInterval      _timeout;
    ALRequestType       _requestType;
    
    /*datas*/
    NSMutableDictionary *_param;
    
    /*动态添加的字段*/
    NSMutableDictionary *_dynamicParam;
    
    /*reuqest headers*/
    NSMutableDictionary *_headers;
    
    /*request body*/
    id  _httpBody;
    
    /*上传二进制数据或文件*/
    NSMutableDictionary *_postDatas;
}

@property (nonatomic, strong) NSString              *urlString;
@property (nonatomic, strong) NSString              *method;
@property (nonatomic, assign) NSTimeInterval        timeout;
@property (nonatomic, assign) ALRequestType         requestType;
@property (nonatomic, strong) NSDictionary        *param;

- (void)addParam:(id)value forKey:(NSString *)key;
- (void)addParams:(NSDictionary *)params;
- (NSDictionary *)headers;

- (void)addHeader:(id)value forKey:(NSString *)key;

- (id)httpBody;

- (void)setHttpBody:(id)body;

- (NSDictionary *)postDatas;

- (void)addData:(NSData *)data forKey:(NSString *)key;

- (void)removePostDataWithKey:(NSString *)key;

- (void)removeAllPostData;

- (void)addFile:(NSData *)fileData forKey:(NSString *)key fileName:(NSString *)fileName mimeType:(NSString *)mimeType;

- (void)addPNGFile:(UIImage *)image forKey:(NSString *)key fileName:(NSString *)fileName;

- (void)addJPEGFile:(UIImage *)image forKey:(NSString *)key fileName:(NSString *)fileName;

@end