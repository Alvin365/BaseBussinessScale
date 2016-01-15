//
//  Frame.m
//  author Kenneth He Xiang Zheng
//
//  Created by mac on 15-3-16.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "Frame.h"
#import "FrameData.h"

@implementation Frame

-(instancetype)init{
    self = [super init];
    if(self){
        _startByte = (Byte)0xA5;
        _dataAreaLen = (Byte)0;
        _dataArea = [[FrameData alloc]init];
        _checkByte = (Byte)0;
        _frameFull = nil;
    }
    return self;
}



-(id)initWithData:(NSData *)data{
    self = [super init];
    if(self){
        // 对数据进行基础性检验
        if(data == nil){
            NSLog(@"FRAME ERROR : 帧为空");
            return nil;
            
        }
        
        _frameFull = data ;
        Byte *frameByte = (Byte *)_frameFull.bytes;
        
        if(frameByte == NULL){
            return nil;
        }
        if(frameByte[0] != (Byte)0xA5){
//            NSLog(@"FRAME ERROR : 帧头不正确");
            return nil;
        
        }
        else if(frameByte[2] != data.length - 4){
            NSLog(@"FRAME ERROR : 数据长度不匹配");
            return nil;
        }
        
        // 对帧数据的一些基础属性进行赋值
        _startByte = (Byte)0xCA; //帧头
        [self setFrameVer:frameByte[1]];//帧版本
        [self setDataAreaLen:frameByte[2]];//数据域长度
        [self setCommandByte:frameByte[3]]; // 命令字节
        [self setCheckByte:frameByte[data.length-1]];//校验位
        
        
        int count = frameByte[2];
        NSRange range = NSMakeRange(3, count -1 );
        NSData * dataArea = [data subdataWithRange:range];
        
        // 通过FrameData对数据正文部分进行解析
        _dataArea = [[FrameData alloc] initWithData:dataArea];
        
//        if([self getDataXor] != _checkByte){
//            NSLog(@"FRAME ERROR : 校验码不正确,不是正确帧   ---:%d",_checkByte);
//            return nil;
//        }
    }
    return self;
}

-(id)initWithBytes:(Byte *)bytes length:(NSUInteger)length {
    self = [super init];
    if (self) {
        self.frameVer = (Byte)bytes[1];
        self.dataAreaLen = (Byte)bytes[2];
        self.dataArea = [[FrameData alloc] init];
        Byte *dataAreaFull = malloc((length-4) *sizeof(Byte));
        for (int i = 0; i < length - 4; i++) {
            dataAreaFull[i] = bytes[3+i];
        }
        self.dataArea.dataAreaFull = [[NSData alloc] initWithBytes:dataAreaFull length:length - 4];
        self.checkByte = [self getDataXor];
        bytes[length-1] = self.checkByte;
        self.frameFull = [[NSData alloc] initWithBytes:bytes length:length];
    }
    return self;
}


/**
 *  获得数据的异或值----校验位,数据范围为版本号开始到正文结束
 *
 *  @return 数据的异或值
 */
-(Byte)getDataXor{
    Byte xor = _frameVer;
    xor ^= _dataAreaLen;
    xor ^= [_dataArea getDataXor];
    return xor;
}

/**
 *  打印数据
 */
-(void)printFrametoString{
    NSLog(@"<startByte:%d>", _startByte);
    NSLog(@"<framVersion:%d>", _frameVer);
    NSLog(@"<dataAreaLen:%d>", _dataAreaLen);
    NSLog(@"<checkData:%d>", _checkByte);
    NSLog(@"<_frameFull:%@>",self.frameFull);
    [_dataArea printFrameDataString];
}



@end
