//
//  ALCommonTool.m
//  BusinessScale
//
//  Created by Alvin on 15/12/16.
//  Copyright © 2015年 Alvin. All rights reserved.
//

#import "ALCommonTool.h"
@implementation ALCommonTool

+ (BOOL)verifyMobilePhone:(NSString*)phone
{
    NSString *regex = @"1[0-9]{10}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:phone] == YES)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSAttributedString*)setAttrbute:(NSString *)string andAttribute:(NSString *)string2 Color1:(UIColor *)color1 Color2:(UIColor *)color2 Font1:(CGFloat)font1 Font2:(CGFloat)font2
{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]init];
    NSAttributedString *attributed = [[NSAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font1],NSForegroundColorAttributeName:color1}];
    [att appendAttributedString:attributed];
    NSAttributedString *attribute = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",string2] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font2],NSForegroundColorAttributeName:color2}];
    
    [att appendAttributedString:attribute];
    return att;
}

+ (void)copyDataBase
{
    [[NSUserDefaults standardUserDefaults]setObject:@(NO) forKey:@"haveCopyDataBase"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    BOOL haveCopy = [[[NSUserDefaults standardUserDefaults]objectForKey:@"haveCopyDataBase"] boolValue];
    if (!haveCopy) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"kind" ofType:@"txt"];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableContainers error:nil];
        
        LKDBHelper *help = [BaseModel getUsingLKDBHelper];
        for (NSString *key in dic.allKeys) {
            GoodsInfoModel *model = [[GoodsInfoModel alloc]init];
            model.title = key;
            model.icon = dic[key];
            [help insertWhenNotExists:model callback:nil];
        }
        
        [[NSUserDefaults standardUserDefaults]setObject:@(YES) forKey:@"haveCopyDataBase"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

@end
