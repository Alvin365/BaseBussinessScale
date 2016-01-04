//
//  ALBaseHttpTool.h
//  BusinessScale
//
//  Created by Alvin on 15/12/28.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALBaseHttpTool : NSObject

/**
 *  发送一个GET请求
 */
+ (void)get:(NSString *)url params:(NSDictionary *)params completedBlock:(void (^)(id result))completedBlock;
/**
 *  发送一个POST请求
 */
+ (void)post:(NSString *)url params:(NSDictionary *)params completedBlock:(void (^)(id result))completedBlock;
/**
 *  发送一个PUT请求
 */
+ (void)put:(NSString *)url params:(NSDictionary *)params completedBlock:(void (^)(id result))completedBlock;
@end
