//
//  ALCommonTool.h
//  BusinessScale
//
//  Created by Alvin on 15/12/16.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALCommonTool : NSObject

/** 手机号正则匹配*/
+(BOOL)verifyMobilePhone:(NSString*)phone;
/** 富文本 字体1，字体2,颜色1，颜色2*/
+ (NSAttributedString*)setAttrbute:(NSString *)string andAttribute:(NSString *)string2 Color1:(UIColor *)color1 Color2:(UIColor *)color2 Font1:(CGFloat)font1 Font2:(CGFloat)font2;
/**
 * 拷贝外部数据库
 */
+ (void)copyDataBase;

@end
