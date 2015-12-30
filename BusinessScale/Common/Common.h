//
//  Common.h
//  BusinessScale
//
//  Created by Alvin on 15/12/15.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#ifndef Common_h
#define Common_h

#ifdef DEBUG // 调试状态, 打开LOG功能
#define ALLog(...) NSLog(__VA_ARGS__)
#else // 发布状态, 关闭LOG功能
#define ALLog(...)
#endif

// 是否大于iOS 7系统
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define iOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0)

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self

#define screenWidth ([UIScreen mainScreen].bounds.size.width)
#define screenHeight ([UIScreen mainScreen].bounds.size.height)
#define ALScreenScalWidth screenWidth/375.0f
#define ALScreenScalHeight screenHeight/667.0f
#define ALSeparaLineHeight 0.5
/** 公共颜色*/
#define ALNavBarColor [UIColor colorWithHexString:@"91be46"]
#define separateLabelColor [UIColor colorWithHexString:@"ebebeb"]
#define backGroudColor [UIColor colorWithHexString:@"f8f8f8"]
#define ALTextColor [UIColor colorWithHexString:@"565656"]
#define ALLightTextColor [UIColor colorWithHexString:@"a2a2a2"]
#define ALRedColor [UIColor colorWithHexString:@"e84c55"]
#define ALDisAbleColor [UIColor colorWithHexString:@"cccccc"]
#define Color(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
// 导航栏标题的字体
#define ALNavigationTitleFont [UIFont boldSystemFontOfSize:18]
#define ALDocuMentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

#define TestServerce @"https://192.168.0.72/s0/"

#endif /* Common_h */
