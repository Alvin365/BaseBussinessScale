//
//  CategorySection.m
//  BusinessScale
//
//  Created by Alvin on 16/1/8.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "CategorySection.h"

@interface CategorySection()

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsL;
@property (weak, nonatomic) IBOutlet UILabel *weightL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;

@property (nonatomic, strong) UILabel *sepT;
@property (nonatomic, strong) UILabel *sepB;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weightRight;

@end

@implementation CategorySection

+ (instancetype)loadXibView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"CategorySection" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    _weightRight.constant = 120*ALScreenScalWidth;
    
    _headImage.layer.cornerRadius = 20;
    _headImage.layer.masksToBounds = YES;
    
    _goodsL.textColor = ALTextColor;
    _weightL.textColor = ALTextColor;
    _priceL.textColor = ALTextColor;
    
    self.backgroundColor = backGroudColor;
    
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    
    _sepT = [[UILabel alloc]init];
    _sepT.backgroundColor = separateLabelColor;
    [self addSubview:_sepT];
    
    _sepB = [[UILabel alloc]init];
    _sepB.backgroundColor = separateLabelColor;
    [self addSubview:_sepB];
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    SaleItem *item = dataArray[0];
    
    CGFloat scale = (CGFloat)[UnitTool defaultUnit]/item.unit;
    CGFloat quantity = item.quantity/scale;
    
    CGFloat totalPrice = 0.0f;
    CGFloat totalWeight = 0.0f;
    for (SaleItem *item in dataArray) {
        totalPrice += item.paid_price/100.0f;
        totalWeight += quantity;
    }
    
    [_headImage setImageWithIcon:item.icon];
    _goodsL.text = item.title;
    
    _priceL.text = [NSString stringWithFormat:@"%@元",[ALCommonTool decimalPointString:totalPrice]];
    _weightL.text = [NSString stringWithFormat:@"%@%@",[ALCommonTool decimalPointString:totalWeight],[UnitTool stringFromWeight:[UnitTool defaultUnit]]];
}

- (void)tap
{
    if (self.callBack) {
        self.callBack();
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.sepT.frame = CGRectMake(0, 0, self.width, 0.5);
    self.sepB.frame = CGRectMake(0, self.height-0.5, self.width, 0.5);
}

@end
