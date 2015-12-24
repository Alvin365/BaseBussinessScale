//
//  ALKeyBordTool.m
//  BusinessScale
//
//  Created by Alvin on 15/12/22.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "ALKeyBordTool.h"

@interface ALKeyBordTool()<UIToolbarDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *completeItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancleItem;

@end

@implementation ALKeyBordTool

+ (instancetype)loadXibView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ALKeyBordTool" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    _toolBar.delegate = self;
    _toolBar.backgroundColor = ALDisAbleColor;
    _toolBar.barTintColor = ALDisAbleColor;
//    self.completeItem.tintColor = ALNavBarColor;
//    self.cancleItem.tintColor = ALNavBarColor;
}

- (IBAction)clickAtIndex:(UIBarButtonItem *)sender {
    if (self.callBack) {
        self.callBack(sender.tag);
    }
}


@end
