//
//  ProcessBussiness.h
//  BusinessScale
//
//  Created by Alvin on 16/1/9.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProcessBussiness : NSObject

/**
 * 按时间查看  type：日、周、月
 */
+ (void)reportFormsAccordingTimeByType:(ALProcessViewButtonTag )type beginDate:(NSDate *)beginDate endDate:(NSDate *)endDate completedBlock:(void(^)(NSArray *dataArray,CGFloat paiPrice,CGFloat totalPrice))block;

/**
 * 按品类查看  type：日、周、月
 */
+ (void)reportFormsAccordingCategoryByType:(ALProcessViewButtonTag )type beginDate:(NSDate *)beginDate endDate:(NSDate *)endDate completedBlock:(void(^)(NSArray *dataArray,CGFloat paiPrice,CGFloat totalPrice))block;

/**
 * 收入记录
 */
+ (void)recordDatasWithDate:(NSDate *)date completedBlock:(void (^)(NSArray *dataArray,CGFloat price))block;

@end
