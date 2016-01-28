//
//  RandomNumFrame.m
//  Commercial-Bluetooth
//
//  Created by ChipSea on 16/1/24.
//  Copyright © 2016年 Chipsea. All rights reserved.
//

#import "RandomNumFrame.h"

@implementation RandomNumFrame

-(id)initWithData:(NSData *)data {
    self = [super initWithData:data];
    if (self) {
        NSData *randData = [data subdataWithRange:NSMakeRange(4, 4)];
        _randomNumStr = [[NSString alloc] initWithData:randData encoding:NSASCIIStringEncoding];
    }
    return self;
}

@end
