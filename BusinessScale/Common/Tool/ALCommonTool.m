//
//  ALCommonTool.m
//  BusinessScale
//
//  Created by Alvin on 15/12/16.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "ALCommonTool.h"

@implementation ALCommonTool

+ (NSAttributedString*)setAttrbute:(NSString *)string andAttribute:(NSString *)string2 Color1:(UIColor *)color1 Color2:(UIColor *)color2 Font1:(CGFloat)font1 Font2:(CGFloat)font2
{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]init];
    NSAttributedString *attributed = [[NSAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font1],NSForegroundColorAttributeName:color1}];
    [att appendAttributedString:attributed];
    NSAttributedString *attribute = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",string2] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font2],NSForegroundColorAttributeName:color2}];
    
    [att appendAttributedString:attribute];
    return att;
}

@end
