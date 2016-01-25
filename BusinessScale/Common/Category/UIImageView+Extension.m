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
        [self sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"default"]];
    }
}

@end
