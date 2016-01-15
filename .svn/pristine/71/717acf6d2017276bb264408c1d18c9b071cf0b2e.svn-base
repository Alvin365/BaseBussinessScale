//
//  SyncTimeFrame.m
//  Commercial-Bluetooth
//
//  Created by ChipSea on 16/1/6.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "SyncTimeFrame.h"

@implementation SyncTimeFrame

-(id)init {
    self = [super init];
    if (self) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *now = [formatter stringFromDate:[NSDate date]];
        
        Byte year = (Byte)0xFF & [[[now substringFromIndex:2] substringToIndex:2] intValue];
        Byte month = (Byte) 0xFF & [[[now substringFromIndex:5] substringToIndex:2] intValue];
        Byte day = (Byte) 0xFF & [[[now substringFromIndex:8] substringToIndex:2] intValue];
        Byte hour = (Byte) 0xFF & [[[now substringFromIndex:11] substringToIndex:2] intValue];
        Byte minute = (Byte) 0xFF & [[[now substringFromIndex:14] substringToIndex:2] intValue];
        Byte sec = (Byte) 0xFF & [[now substringFromIndex:17] intValue];
        
        Byte bytes[] = {0xA5, 0x10, 0x07, 0x11, year, month, day, hour, minute, sec, 0x00};
        self = [super initWithBytes:bytes length:11];
    }
    return self;
}

@end
