//
//  ALWorkRequest.h
//  BusinessScale
//
//  Created by Alvin on 15/12/31.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALRequestParam.h"
#import <AFNetworking.h>
@interface ALWorkRequest : AFHTTPRequestOperation {
    NSString                    *_identifier;
    ALRequestParam              *_requestParam;
    NSError                     *_error;
}

@property (nonatomic, strong, readonly) NSString        *identifier;
@property (nonatomic, strong, readonly) ALRequestParam  *requestParam;
@property (nonatomic, assign, readonly) NSInteger       responseStatusCode;
@property (nonatomic, readonly)         NSError         *error;

- (id)initWithParam:(ALRequestParam *)param;
- (void)setReturnBlock:(void(^)(NSObject *obj))block;

@end
