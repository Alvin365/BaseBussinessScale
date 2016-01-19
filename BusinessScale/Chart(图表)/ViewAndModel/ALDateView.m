//
//  DateView.m
//  BusinessScale
//
//  Created by Alvin on 16/1/14.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "ALDateView.h"

@interface ALDateView()




@end

@implementation ALDateView

+ (instancetype)loadXibView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ALDateView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)]];
}

- (void)tapClick:(UIGestureRecognizer *)reconizer
{
    CGPoint point = [reconizer locationInView:reconizer.view];
    DateViewDirection tag = point.x>=self.width/2.0f?DateViewDirectionRight:DateViewDirectionLeft;
    if (self.callBack) {
        self.callBack(tag);
    }
}

@end
