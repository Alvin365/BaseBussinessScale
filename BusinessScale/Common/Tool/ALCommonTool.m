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

+ (BOOL)isNewFeature
{
    NSString *versionKey = @"CFBundleShortVersionString";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults objectForKey:versionKey];
    
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionKey];
    if ([currentVersion isEqualToString:lastVersion]) {
        return NO;
    }else{
        [defaults setObject:currentVersion forKey:versionKey];
        [defaults synchronize];
        return YES;
    }
}

NSString * DPLocalizedString(NSString * translation_key, id comment) {
    NSString * s = NSLocalizedString(translation_key, nil);
    if ([CURR_LANG hasPrefix:@"zh"]) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"zh" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    } else if (![CURR_LANG isEqual:@"en"] && ![CURR_LANG hasPrefix:@"zh"]) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        s = [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
    }
    if ([s rangeOfString:@";#PRODUCT_NAME#;"].location != NSNotFound) {
        s = [s stringByReplacingOccurrencesOfString:@";#PRODUCT_NAME#;" withString:DPLocalizedString(@"product_name", @"product name")];
    }
    return s;
}



@end
