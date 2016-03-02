//
//  AccountTool.m
//  showTalence
//
//  Created by iMAC001 on 15/4/28.
//  Copyright (c) 2015年 Alvin. All rights reserved.
//

#define AccountFilepath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]

#import "AccountTool.h"
@implementation AccountModel

MJCodingImplementation
//- (id)initWithCoder:(NSCoder *)decoder
//{
//    if (self = [super init]) {
//        self.token = [decoder decodeObjectForKey:@"access_token"];
//        self.ID = [decoder decodeObjectForKey:@"ID"];
//        self.phone = [decoder decodeObjectForKey:@"phone"];
//        self.nickName = [decoder decodeObjectForKey:@"nickName"];
//        self.weichatNo = [decoder decodeObjectForKey:@"weichatNo"];
//        self.alipayNo = [decoder decodeObjectForKey:@"alipayNo"];
//    }
//    return self;
//}
//
///**
// *  将对象写入文件的时候调用
// *  在这个方法中写清楚：要存储哪些对象的哪些属性，以及怎样存储属性
// */
//- (void)encodeWithCoder:(NSCoder *)encoder
//{
//    [encoder encodeObject:self.token forKey:@"access_token"];
//    [encoder encodeObject:self.ID forKey:@"ID"];
//    [encoder encodeObject:self.phone forKey:@"phone"];
//    [encoder encodeObject:self.nickName forKey:@"nickName"];
//    [encoder encodeObject:self.weichatNo forKey:@"weichatNo"];
//    [encoder encodeObject:self.alipayNo forKey:@"alipayNo"];
//}

@end

@implementation AccountTool

+ (void)saveAccount:(AccountModel *)model
{
    [NSKeyedArchiver archiveRootObject:model toFile:AccountFilepath];
}

+ (AccountModel *)account
{
    AccountModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:AccountFilepath];
    if (!model) {
        model = [[AccountModel alloc]init];
    }
    return model;
}
@end
