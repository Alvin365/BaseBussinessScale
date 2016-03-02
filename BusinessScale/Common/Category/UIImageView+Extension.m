//
//  UIImageView+Extension.m
//  BusinessScale
//
//  Created by Alvin on 16/1/25.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "UIImageView+Extension.h"

@implementation UIImageView (Extension)

- (void)setImageWithIcon:(NSString *)icon
{
    if ([icon hasPrefix:@"img"]) {
        self.image = [UIImage imageFromSeverName:icon];
    }else{
        NSString *iconURL = [NSString stringWithFormat:@"%@inventory/icon/%@",userServerce,icon];
        [self sd_setImageWithURL:[NSURL URLWithString:iconURL]placeholderImage:[UIImage imageNamed:@"default"]];
    }
}

@end
