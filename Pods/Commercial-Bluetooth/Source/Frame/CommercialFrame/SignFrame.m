//
//  SignFrame.m
//  Commercial-Bluetooth
//
//  Created by ChipSea on 16/1/24.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "SignFrame.h"
#import <CommonCrypto/CommonDigest.h>

@implementation SignFrame

-(id)initWithRandomNum:(NSString *)randomNum pin:(NSString *)pin {
    self = [super init];
    if (self) {
        NSString *sign = [self getMD5String:[NSString stringWithFormat:@"%@%@", randomNum, pin]];
        NSMutableData *signData = [[NSMutableData alloc] initWithBytes:(Byte[]){0xA5, 0x01, 0x10, 0x43} length:4];
//        [signData appendData:[sign dataUsingEncoding:NSUTF8StringEncoding]];
        [signData appendBytes:[sign dataUsingEncoding:NSUTF8StringEncoding].bytes length:15];
        [signData appendBytes:(Byte[]){0x00} length:1];
        self = [super initWithData:signData];
    }
    return self;
}

/**
 *  MD5加密
 *
 *  @param str 需要加密的字符串
 *
 *  @return 加密后的字符串
 */
-(NSString *)getMD5String:(NSString *)str {
    /////  MD5  加密
    const char * original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString * hash = [NSMutableString string];
    for(int i=0 ; i< 16; i++)
    {
        [hash appendFormat:@"%02X",result[i]];
    }
    return [hash uppercaseString];
}
@end
