//
//  NSObject+Extention.m
//  BusinessScale
//
//  Created by Alvin on 16/2/18.
//  Copyright © 2016年 Alvin. All rights reserved.
//

#import "NSObject+Extention.h"

@implementation NSObject (Extention)

- (NSString*)jsonString
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
