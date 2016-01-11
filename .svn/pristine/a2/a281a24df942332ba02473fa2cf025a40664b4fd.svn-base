//
//  ALWorkRequest.h
//  BusinessScale
//
//  Created by Alvin on 15/12/31.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALRequestParam.h"

@interface ALWorkRequest : NSObject

@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) ALRequestParam  *requestParam;
@property (nonatomic, assign, readonly) NSInteger       responseStatusCode;
@property (nonatomic, readonly)         NSError         *error;

- (id)initWithParam:(ALRequestParam *)param;
- (void)setReturnBlock:(void(^)(NSURLSessionTask *task,NSURLResponse *response,id responseObject))block;

@end
