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

+ (BOOL)isFirstInstall
{
    BOOL isFirst = ![[[NSUserDefaults standardUserDefaults]objectForKey:@"isFirst"]boolValue];
    if (isFirst) {
        [[NSUserDefaults standardUserDefaults]setObject:@(YES) forKey:@"isFirst"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    return isFirst;
}

+ (BOOL)haveNewGoods:(NSInteger)goodsCount
{
    NSInteger count = [[[NSUserDefaults standardUserDefaults]objectForKey:@"goodsCount"]integerValue];
    return goodsCount != count;
}

+ (void)saveGoodsCount:(NSInteger)goodsCount
{
    [[NSUserDefaults standardUserDefaults]setObject:@(goodsCount) forKey:@"goodsCount"];
    [[NSUserDefaults standardUserDefaults]synchronize];
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

/**
 *  获得当前系统语言
 *
 *  @return 当前系统语言
 */
+ (NSString*)getPreferredLanguage {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    if (![preferredLang hasPrefix:@"zh"]) {
        return @"en";
    }
    //    NSLog(@"当前语言:%@", preferredLang);
    return preferredLang;
}
/**
 * 是否含有非法字符
 */
+ (Boolean)hasillegalString:(NSString *)str
{
    if ( str.length == 0 )  // 目前允许是空
    {
        return NO;
    }
    NSString *regex = @"^[a-zA-Z0-9_\u4e00-\u9fa5]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:str] == YES)
    {
        return  NO;
    }
    else
    {
        return YES;
    }
    
    NSCharacterSet *disallowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"~!！￥@#$%^&*+?/="] invertedSet];
    NSRange foundRange = [str rangeOfCharacterFromSet:disallowedCharacters];
    
    NSLog( @"%@", str );
    
    if (foundRange.location == NSNotFound)
    {
        ALLog(@"含有非法字符");
        return YES;
    }
    
    return NO;
}

+ (NSString *)decimalPointString:(CGFloat)value
{
    NSString *string = [NSString stringWithFormat:@"%g",value];
    NSString *decimalString = [[string componentsSeparatedByString:@"."]lastObject];
    if (decimalString.length>2 && ![decimalString isEqualToString:string]) {
        string = [NSString stringWithFormat:@"%.2f",value];
//        if (![decimalString integerValue]) {
//            string = [NSString stringWithFormat:@"%.f",value];
//        }
    }
    return string;
}

@end
