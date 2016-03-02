//
//  LocalDataTool.m
//  showTalence
//
//  Created by iMAC001 on 15/5/13.
//  Copyright (c) 2015年 Alvin. All rights reserved.
//

#import "LocalDataTool.h"
#define ALDocuMentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
@implementation LocalDataTool

+ (void)saveAsLocalDicWithPath:(NSString *)path data:(NSDictionary *)dic
{
    if (!dic) {
        return;
    }
    NSString *path1 = [ALDocuMentPath stringByAppendingPathComponent:path];
    [dic writeToFile:path1 atomically:YES];
}

+ (NSDictionary *)loadLocalDicFromPath:(NSString *)path
{
    NSString *path1 = [ALDocuMentPath stringByAppendingPathComponent:path];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:path1];
    return dic;
}

+ (void)removeDocumAtPath:(NSString *)path
{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *path1 = [ALDocuMentPath stringByAppendingPathComponent:path];
    BOOL bRet = [fileMgr fileExistsAtPath:path1];
    if (bRet) {
        NSError *err;
        [fileMgr removeItemAtPath:path1 error:&err];
    }
}

+ (void)saveAsLocalArrayWithPath:(NSString *)path data:(NSArray *)arr
{
    if (!arr) {
        return;
    }
    NSString *path1 = [ALDocuMentPath stringByAppendingPathComponent:path];
    [arr writeToFile:path1 atomically:YES];
}

+ (NSArray *)loadLocalArrayFromPath:(NSString *)path
{
    NSString *path1 = [ALDocuMentPath stringByAppendingPathComponent:path];
    NSArray *arr = [[NSArray alloc]initWithContentsOfFile:path1];
    return arr;
}

+ (void)saveAsLocalImageWithData:(NSData *)data
{
    if (!data) {
        return;
    }
    
    NSString *path1 = [ALDocuMentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",@"headImage"]];
    [data writeToFile:path1 atomically:YES];
}

+ (UIImage *)loadLocalImage
{
    NSString *path1 = [ALDocuMentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",@"headImage"]];
    UIImage  *image = [[UIImage alloc]initWithContentsOfFile:path1];
    return image;
}

+ (void)removeAllLocalDatas
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
//
//    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *fileList;
    
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    fileList = [fileManager contentsOfDirectoryAtPath:cache error:NULL];
    for (NSString *file in fileList) {
        NSString *path =[cache stringByAppendingPathComponent:file];
        [fileManager removeItemAtPath:path error:nil];
    }
    
    ALLog(@"%@",NSHomeDirectory());
}

+ (long long)fileSizeAtPath:(NSString*)filePath
{
    NSString *path1 = [ALDocuMentPath stringByAppendingPathComponent:filePath];
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path1]){
        return [[manager attributesOfItemAtPath:path1 error:nil] fileSize];
    }
    return 0;
}
// 遍历文件夹获得文件夹大小，返回多少M
+ (float )folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

+ (float)allFolderSize
{
//    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    float folderSize = 0;
//    folderSize += [self folderSizeAtPath:document];
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    folderSize += [self folderSizeAtPath:cache];
//    NSString *Libaray =  [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
//    folderSize += [self folderSizeAtPath:Libaray];
    return folderSize;
}

+ (NSDictionary *)getGoodsList
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"kind" ofType:@"txt"];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableContainers error:nil];
    return dic;
}

@end
