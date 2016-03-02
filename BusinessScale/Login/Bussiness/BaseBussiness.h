//
//  BaseBussiness.h
//  BusinessScale
//
//  Created by Alvin on 16/2/19.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseBussiness : NSObject

+ (void)doDatasFromNet:(NSObject *)resuilt useFulData:(void (^)(NSObject *data ))data;

@end
