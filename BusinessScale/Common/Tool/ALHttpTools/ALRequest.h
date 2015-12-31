//
//  ALRequest.h
//  BusinessScale
//
//  Created by Alvin on 15/12/31.
//  Copyright © 2015年 Alvin. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ALRequestMethod){
    ALRequestMethod_Get = 0,
    ALRequestMethod_Post,
    ALRequestMethod_PostMulty,
    ALRequestMethod_Put,
    ALRequestMethod_PutMulty,
};


@interface ALRequest : NSObject



@end
