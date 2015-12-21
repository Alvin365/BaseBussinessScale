//
//  ALProcessView.h
//  BusinessScale
//
//  Created by Alvin on 15/12/16.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , ALProcessViewButtonTag) {
    ALProcessViewButtonTagDay = 0,
    ALProcessViewButtonTagWeek,
    ALProcessViewButtonTagMonth,
    ALProcessViewButtonTagRecord
};

@interface ProcessButton : UIButton

@end

@interface ALProcessView : UIView

@property (nonatomic, copy) void(^callBack) (ALProcessViewButtonTag tag);

@end
