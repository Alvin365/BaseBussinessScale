//
//  UIImage+Extension.h
//
//  Created by apple on 14-7-3.
//  Copyright (c) 2014年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/**  根据图片名和边界返回一张拉伸图片*/
+ (UIImage *)strechImageWithName:(NSString *)name imagEdge:(UIEdgeInsets)edge;
/**  根据图片名自动加载适配iOS6\7的图片*/
+ (UIImage *)imageWithName:(NSString *)name;
/**  根据图片名返回一张能够自由拉伸的图片*/
+ (UIImage *)resizedImage:(NSString *)name;
/** 根据大小  匹配图片*/
- (UIImage *)compressImageWithSize:(CGSize)viewsize;
/** 根据图片名返回原始图片*/
+ (UIImage *)orignImage:(NSString *)name;
/** 根据颜色创建图片*/
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
/** 校正上传图片的方向*/
- (UIImage *)fixOrientation;
/** 根据图片名返回一张不占内存缓存的图片*/
+ (UIImage *)ALImageWithName:(NSString *)name;
/** 截屏图片*/
+ (UIImage *)capture:(UIView *)view;
/** 图片自适应宽高*/
- (UIImage *)rescaleImageToSize:(CGSize)size;
/**
 * 按给定的比例 裁剪出一张居中且为给定比例的图片
 */
- (UIImage *)imageCutRectByScale:(CGSize)scaleSize;

@end
