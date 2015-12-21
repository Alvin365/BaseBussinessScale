//
//  GoodsSwapCell.m
//  BusinessScale
//
//  Created by Alvin on 15/12/15.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "GoodsSwapCell.h"
@interface GoodsSwapCell ()

@property (nonatomic, strong) UILabel *topL;

@end

@implementation GoodsSwapCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier containingTableView:containingTableView leftUtilityButtons:leftUtilityButtons rightUtilityButtons:rightUtilityButtons]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _goodsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, self.centerY-22.5*ALScreenScalHeight, 45*ALScreenScalHeight, 45*ALScreenScalHeight)];
    _goodsImageView.layer.cornerRadius= 22.5*ALScreenScalHeight;
    _goodsImageView.layer.masksToBounds = YES;
    _goodsImageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_goodsImageView];
    
    _goodsL = [[UILabel  alloc]initWithFrame:CGRectMake(_goodsImageView.right+10, self.centerY-10, 100, 20)];
    _goodsL.textColor = [UIColor colorWithHexString:@"585858"];
    _goodsL.font = [UIFont systemFontOfSize:15];
    _goodsL.text = @"西兰花";
    [self.contentView addSubview:_goodsL];
    
    _weightL = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2.0f-100, self.centerY-10, 200, 20)];
    _weightL.textAlignment = NSTextAlignmentCenter;
    _weightL.textColor = [UIColor colorWithHexString:@"666666"];
    _weightL.text = @"3.25斤";
    _weightL.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:_weightL];
    
    _priceL = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth-120, self.centerY-10, 100, 20)];
    _priceL.text = @"5.8元";
    _priceL.textAlignment = NSTextAlignmentRight;
    _priceL.textColor = [UIColor colorWithHexString:@"90bf46"];
    _priceL.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_priceL];
    
    _topL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 0.5)];
    _topL.backgroundColor = separateLabelColor;
    [self addSubview:_topL];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _goodsImageView.y = self.height/2.0f-22.5*ALScreenScalHeight;
    _goodsL.y = self.height/2.0f-10;
    _weightL.y = self.height/2.0f-10;
    _priceL.y = self.height/2.0f-10;
}

@end
