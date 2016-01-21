//
//  SelectImageOptionView.h
//  Patient
//
//  Created by chens on 14-10-21.
//  Copyright (c) 2014年 Alvin. All rights reserved.
//
typedef enum {
    selectBtnTagAbum,
    selectBtnTagCamera
}selectBtnTag;
#import <UIKit/UIKit.h>

@interface SelectImageOptionView : UIView
@property(nonatomic,strong)UIButton*getFromCamera;
@property(nonatomic,strong)UIButton*selectFromAlbum;

@property (nonatomic, copy) void(^callBtnBack)(selectBtnTag tag);
-(void)showFromBottom;
@end
