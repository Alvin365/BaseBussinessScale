//
//  OpenBleController.h
//  btWeigh
//
//  Created by mac on 15/6/1.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface OpenBleController : BaseViewController {
    // 由于Pan是会一直调用回调函数
    // 所以设置改变了防止多次PushViewController
    BOOL isPushing;
}

@property (weak, nonatomic) IBOutlet UIImageView *kUIBackground;

@end
