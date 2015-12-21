//
//  CALayer+ALAnimation.h
//  BusinessScale
//
//  Created by Alvin on 15/12/20.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (ALAnimation)

/** 缩放 中心点位置 bouns从小到大*/
- (void)layerZoomIn;
/** 缩放 中心点位置 bouns从大到小*/
- (void)layerZoomOut;
/**右旋转*/
- (void)layerRotateRight;
/**左旋转*/
- (void)layerRotateLeft;
/** 缩放 中心点位置 bouns从小到大加旋转*/
- (void)layerAnimateZoomInAndRoate;
/** 缩放 中心点位置 bouns从大到小加旋转*/
- (void)layerAnimateZoomOutAndRoate;

@end
