//
//  LocalDataTool.h
//  showTalence
//
//  Created by iMAC001 on 15/5/13.
//  Copyright (c) 2015年 Alvin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalDataTool : NSObject
/** 保存为本地键值对数据*/
+ (void)saveAsLocalDicWithPath:(NSString *)path data:(NSDictionary *)dic;
/** 读取本地键值对数据*/
+ (NSDictionary *)loadLocalDicFromPath:(NSString *)path;
/** 保存为本地数组数据*/
+ (void)saveAsLocalArrayWithPath:(NSString *)path data:(NSArray *)arr;
/** 读取本地数组数据*/
+ (NSArray *)loadLocalArrayFromPath:(NSString *)path;
/** 保存本地头像*/
+ (void)saveAsLocalImageWithData:(NSData *)data;
/** 读取本地头像*/
+ (UIImage *)loadLocalImage;

+ (void)removeAllLocalDatas;
/**
 * 某文件的大小
 */
+ (long long)fileSizeAtPath:(NSString*)filePath;
/**
 * 所有文件大小 
 */
+ (float)allFolderSize;

+ (NSDictionary *)getGoodsList;
/**
 * 删除某路径的文件
 */
+ (void)removeDocumAtPath:(NSString *)path;

@end
