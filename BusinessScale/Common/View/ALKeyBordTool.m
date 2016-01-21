//
//  ALKeyBordTool.m
//  BusinessScale
//
//  Created by Alvin on 15/12/22.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "ALKeyBordTool.h"

@interface ALKeyBordTool()<UIToolbarDelegate>

@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *completedBtn;

@property (nonatomic, strong) UILabel *sepT;

@end

@implementation ALKeyBordTool

+ (instancetype)loadXibView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ALKeyBordTool" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    self.backgroundColor = ALDisAbleColor;
    [self.cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.completedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.cancleItem.tintColor = ALNavBarColor;
    _sepT = [[UILabel alloc]init];
    _sepT.backgroundColor = separateLabelColor;
    [self addSubview:_sepT];
}

- (IBAction)btnClick:(UIButton *)sender {
    if (self.callBack) {
        self.callBack(sender.tag);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _sepT.frame = CGRectMake(0, 0, self.width, ALSeparaLineHeight);
}

@end
