//
//  UIImage+Extension.m
//
//  Created by apple on 14-7-3.
//  Copyright (c) 2014年 Alvin. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (UIImage *)strechImageWithName:(NSString *)name imagEdge:(UIEdgeInsets)edge
{
    UIImage* img=[UIImage ALImageWithName:name];//原图
    img= [img resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
    return img;
}

+ (UIImage *)imageWithName:(NSString *)name
{
    UIImage *image = nil;
    if (iOS7) { // 处理iOS7的情况
        NSString *newName = [name stringByAppendingString:@"_os7"];
        image = [UIImage ALImageWithName:newName];
    }
    
    if (image == nil) {
        image = [UIImage ALImageWithName:name];
    }
    return image;
}

+ (UIImage *)resizedImage:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

- (UIImage *)compressImageWithSize:(CGSize)viewsize
{
    UIImage *image = self;
    CGFloat imgHWScale = image.size.height/image.size.width;
    CGFloat viewHWScale = viewsize.height/viewsize.width;
    CGRect rect = CGRectZero;
    if (imgHWScale>viewHWScale)
    {
        rect.size.height = viewsize.width*imgHWScale;
        rect.size.width = viewsize.width;
        rect.origin.x = 0.0f;
        rect.origin.y =  (viewsize.height - rect.size.height)*0.5f;
    }
    else
    {
        CGFloat imgWHScale = image.size.width/image.size.height;
        rect.size.width = viewsize.height*imgWHScale;
        rect.size.height = viewsize.height;
        rect.origin.y = 0.0f;
        rect.origin.x = (viewsize.width - rect.size.width)*0.5f;
    }
//    CGImageRef imageref = CGImageCreateWithImageInRect(image.CGImage, rect);
//    UIImageView* cropImage = [[UIImageView alloc]initWithFrame:CGRectMake(100, 300, 200, 50)];
//    cropImage.image = [UIImage imageWithCGImage:imageref];
//    CGImageRelease(imageref);
//    return rect;
//    return cropImage;
//    rect = CGRectMake(2*rect.origin.x, 2*rect.origin.y, 2*rect.size.width, 2*rect.size.height);
    UIGraphicsBeginImageContext(viewsize);
    UIGraphicsBeginImageContextWithOptions(viewsize, NO, 6.0f);
    [image drawInRect:rect];
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//
    return newimg;
}

+ (UIImage *)orignImage:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)fixOrientation
{
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
        {
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
        }
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        {
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
        }
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
        {
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
        }
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
        {
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
        }
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
        {
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
        }
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (UIImage *)ALImageWithName:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
    if (!path) {
        path = [[NSBundle mainBundle] pathForResource:name ofType:@"jpg"];
    }
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

+ (UIImage *)capture:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(screenWidth, screenHeight), YES, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)rescaleImageToSize:(CGSize)size {
    
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    [self drawInRect:rect];  // scales image to rect
    
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resImage;
}

- (UIImage *)imageCutRectByScale:(CGSize)viewSize
{
    UIImage *sourceImage = self;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGRect rect = CGRectZero;
    CGFloat scaleH = viewSize.height;
    CGFloat scaleW = viewSize.width;
    
    CGFloat x;
    if (height/width==scaleH/scaleW) {
        return self;
    }else if (height/width>scaleH/scaleW) {
        x = ((scaleW*height-scaleH*width)/scaleW);
        rect.origin.y = (x/2.0f)/(height/scaleH);
        rect.origin.x = 0;
        rect.size.width = (width/scaleW)/(height/scaleH);
        rect.size.height = (height-x)/(height/scaleH);
    }else{
        x = ((scaleH*width-scaleW*height)/scaleH);
        rect.origin.y = 0;
        rect.origin.x = (x/2.0f)/(width/scaleW);
        rect.size.width = (width-x)/(width/scaleW);
        rect.size.height = height/(width/scaleW);
    }
//    UIGraphicsBeginImageContext(targetSize); // this will crop
//    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 2.0f);
    //pop the context to get back to the default
//    UIGraphicsBeginImageContextWithOptions(viewSize, NO, 2.0f);
    UIGraphicsBeginImageContext(viewSize);
    [self drawInRect:rect];
    UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return resImage;
}

@end
