//
//  PalletSecctionView.m
//  BusinessScale
//
//  Created by Alvin on 15/12/16.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "PalletSecctionView.h"

@interface PalletSecctionView()

@property (weak, nonatomic) IBOutlet UIView *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *smallValid;
@end

@implementation PalletSecctionView

+ (instancetype)loadXibView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PalletSecctionView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    self.backgroundColor = backGroudColor;
    _palletNameL.textColor = ALTextColor;
    
    _smallValid.textColor = [UIColor whiteColor];
    _smallValid.layer.cornerRadius = 10;
    _smallValid.layer.masksToBounds = YES;
    _smallValid.backgroundColor = ALNavBarColor;
    
    _TotalPriceL.textColor = ALTextColor;
    
    _selectBtn.backgroundColor = [UIColor clearColor];
    [_selectBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)]];
}

- (void)tapClick
{
    if (self.callBack) {
        self.callBack();
    }
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    if (_selected) {
        self.seletedImagV.image = [UIImage imageNamed:@"icon_sel"];
    }else{
        self.seletedImagV.image = [UIImage imageNamed:@"icon_nor"];
    }
}

@end
