//
//  GoodsHeader.m
//  BusinessScale
//
//  Created by Alvin on 15/12/18.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "GoodsHeader.h"

@interface GoodsHeader()

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *infoL;
@property (weak, nonatomic) IBOutlet UILabel *syL;
@property (weak, nonatomic) IBOutlet UILabel *iconL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *numberL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberLeading;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceTailing;


@end

@implementation GoodsHeader

+ (instancetype)loadXibView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"GoodsHeader" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    self.infoL.textColor = ALNavBarColor;
    self.syL.backgroundColor = ALNavBarColor;
    self.syL.layer.cornerRadius = 17.5;
    self.syL.layer.masksToBounds = YES;
    self.syL.userInteractionEnabled = YES;
    
    UILabel *topL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth, ALSeparaLineHeight)];
    topL.backgroundColor = separateLabelColor;
    [self.bottomView addSubview:topL];
    
    UILabel *bottomL = [[UILabel alloc]initWithFrame:CGRectMake(0, 130-ALSeparaLineHeight, screenWidth, ALSeparaLineHeight)];
    bottomL.backgroundColor = separateLabelColor;
    [self addSubview:bottomL];
    
    self.bottomView.backgroundColor = backGroudColor;
    self.iconL.textColor = ALLightTextColor;
    self.nameL.textColor = ALLightTextColor;
    self.numberL.textColor = ALLightTextColor;
    self.priceL.textColor = ALLightTextColor;
    
    self.iconLeading.constant = 12.0f*ALScreenScalWidth+8;
    self.nameLeading.constant = 90.0f*ALScreenScalWidth+8;
    self.numberLeading.constant = 190.0f*ALScreenScalWidth+8;
    self.priceTailing.constant = 35.0f*ALScreenScalWidth;
    
    [self.syL addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
}

- (void)tap
{
    if (self.callBack) {
        self.callBack();
    }
}

@end
