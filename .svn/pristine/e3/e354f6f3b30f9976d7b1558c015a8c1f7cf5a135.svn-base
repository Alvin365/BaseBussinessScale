//
//  FrameData.m
//  test
//
//  Created by mac on 15-3-16.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "FrameData.h"

@implementation FrameData

-(id)initWithData:(NSData *)data{
    
    self = [super init];
    if(self){
        self.dataAreaFull = data;
    }
    
    return self;
}


-(Byte)getDataXor{
    Byte *dataByte = (Byte *)self.dataAreaFull.bytes;
    Byte xor = dataByte[0];
    for(int i=1;i<self.dataAreaFull.length;i++){
        xor ^= dataByte[i];
    }    
    return xor;
}



-(void)printFrameDataString{
    NSLog(@"------------dataArea---------------");
    NSLog(@"<dataArea:%@>",self.dataAreaFull);
}
@end
