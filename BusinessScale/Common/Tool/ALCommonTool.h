//
//  ALCommonTool.h
//  BusinessScale
//
//  Created by Alvin on 15/12/16.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CURR_LANG ([[NSLocale preferredLanguages] objectAtIndex:0])
@interface ALCommonTool : NSObject

/** 手机号正则匹配*/
+(BOOL)verifyMobilePhone:(NSString*)phone;
/** 富文本 字体1，字体2,颜色1，颜色2*/
+ (NSAttributedString*)setAttrbute:(NSString *)string andAttribute:(NSString *)string2 Color1:(UIColor *)color1 Color2:(UIColor *)color2 Font1:(CGFloat)font1 Font2:(CGFloat)font2;
/**
 * 拷贝外部数据库
 */
+ (void)copyDataBase;
/**
 * 是否是新特性 (新版本)
 */
+ (BOOL)isNewFeature;

/**
 * 是否第一次安装
 */

+ (BOOL)isFirstInstall;

/**
 * 是否有新物品
 */
+ (BOOL)haveNewGoods:(NSInteger)goodsCount;
/**
 * 保存最新物品数
 */
+ (void)saveGoodsCount:(NSInteger)goodsCount;

/**
 * 本地化
 */
NSString * DPLocalizedString(NSString * translation_key, id comment);

+ (NSString*)getPreferredLanguage;

+ (Boolean)hasillegalString:(NSString *)str;

@end
