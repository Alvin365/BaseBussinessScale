//
//  CsBtUtil.m
//  author Kenneth He Xiang Zheng
//
//  Created by mac on 15-3-16.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "CsBtUtil.h"
#import "BroadcastFrame.h"
#import "StraightFrame.h"
#import "StatisticDataFrame.h"
#import "SyncTimeRespFrame.h"
#import "SUPRespFrame.h"

static CsBtUtil *csUtil = nil;

@interface CsBtUtil() {
    NSTimer *connectMonitor;
}

@end

@implementation CsBtUtil 

#pragma mark -单例模式获取
+(CsBtUtil *)getInstance {
    if (csUtil == nil) {
        csUtil = [[CsBtUtil alloc] init];
        [csUtil initCBCentralManager];
    }
    return csUtil;
}

-(void)initCBCentralManager {
    btIsOpen = NO;
    //TODO: 暂时先将老是弹出的窗口屏蔽一下
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], CBCentralManagerOptionShowPowerAlertKey, nil];
    _manager = [[CBCentralManager alloc]initWithDelegate:self queue:nil options:options];
}


#pragma mark - ovveride
-(id)init{
    @synchronized(self) {
        self = [super init];
        if(self){
            self.stopAdvertisementState = NO;
        }
        return self;
    }
}

#pragma mark - CBCentralManagerDelegate
#pragma mark 打开蓝牙回调本函数，告诉我们蓝牙状态
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            NSLog(@"蓝牙已经打开");
            if(self.state == CsScaleStateClosed) {
                csUtil.stopAdvertisementState = NO;
                [csUtil startScanBluetoothDevice];
                if (_delegate != nil) {
                    if ([_delegate respondsToSelector:@selector(didUpdateCsScaleState:)]) {
                        [_delegate didUpdateCsScaleState:CsScaleStateOpened];
                    }
                }
            } else if(self.state == CsScaleStateBroadcast || !btIsOpen) {
                [self startScanBluetoothDevice];
            }
            self.state = CsScaleStateOpened;
            btIsOpen = YES;
          break;
        case CBCentralManagerStatePoweredOff:
            csUtil.stopAdvertisementState = YES;
            [csUtil stopScanBluetoothDevice];
            NSLog(@"蓝牙已经关闭");
            self.state = CsScaleStateClosed;
            if (_delegate != nil) {
                if ([_delegate respondsToSelector:@selector(didUpdateCsScaleState:)]) {
                    [_delegate didUpdateCsScaleState:CsScaleStateClosed];
                }
            }
            btIsOpen = NO;
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"正在重置状态");
            break;
        default:
            break;
    }
}

/**
 在这个函数中，就是用来当搜索到设备的时候回调
 */
#pragma mark 发现设备回调函数,广播
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    NSLog(@"didDiscoverPeripheral");
    //停止搜索
    if(_stopAdvertisementState){
        [_manager stopScan];
        return;
    }
    
    NSData *data = [advertisementData objectForKey:@"kCBAdvDataManufacturerData"];//获得广播设备信息
    if(data){
        //当前搜索到的广播
        if([self.delegate respondsToSelector:@selector(currentAdvertisementData:)]){
            [self.delegate currentAdvertisementData:data];
        }
        
        if(data.length < 6){
            return;
        }
        //当前为Chipsea公司的广播
        NSData *realData = [data subdataWithRange:NSMakeRange(0, data.length-6)];
        NSData *macData = [data subdataWithRange:NSMakeRange(data.length-6, 6)];
        NSString *macTmp1 = [[macData description]substringWithRange:NSMakeRange(1, 2)];
        NSString *macTmp2 = [[macData description]substringWithRange:NSMakeRange(3, 2)];
        NSString *macTmp3 = [[macData description]substringWithRange:NSMakeRange(5, 2)];
        NSString *macTmp4 = [[macData description]substringWithRange:NSMakeRange(7, 2)];
        NSString *macTmp5 = [[macData description]substringWithRange:NSMakeRange(10, 2)];
        NSString *macTmp6 = [[macData description]substringWithRange:NSMakeRange(12, 2)];
        NSString *macString = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",macTmp1,macTmp2,macTmp3,macTmp4,macTmp5,macTmp6 ];
        
        self.activePeripheral = peripheral; //在这里同时设置 全局变量！

//        NSLog(@"----%@  ----%@ ----%@",realData,data,macData);
        BroadcastFrame *frame = [[BroadcastFrame alloc] initWithData:realData];
        if (frame != nil) {
            frame.data.mac = macString;
            if (_delegate != nil && [_delegate respondsToSelector:@selector(discoverBroadcastData:fromPeripheral:)]) {
                [_delegate discoverBroadcastData:frame.data fromPeripheral:peripheral];
            }
        }
    }
}

- (void)connectToPeripheral:(CBPeripheral *)peripheral
{
    [_manager connectPeripheral:peripheral options:nil];
}

/**
    扫描外设中的服务
 */
#pragma mark 扫描到外设之后回调
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"didConnectPeripheral");
    if(self.activePeripheral != peripheral){
//        NSLog(@"%@ --> Peripheral change ... ",TAG);
        self.activePeripheral = peripheral;
    }
    [_manager stopScan];
    if (connectMonitor != nil) {
        [connectMonitor invalidate];
        connectMonitor = nil;
    }
    [peripheral setDelegate:self];  //查找服务
//    [peripheral discoverServices:nil];
    // 请求周边寻找服务
    [peripheral discoverServices:@[[CBUUID UUIDWithString:ISSC_SERVICE_UUID]]];
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"didFailToConnectPeripheral");
    self.state = CsScaleStateOpened;
    if (connectMonitor != nil) {
        [connectMonitor invalidate];
        connectMonitor = nil;
    }
}


/**
    找到对应服务之后,回调函数
 */
#pragma mark 扫描到外设的服务之后回调
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    NSLog(@"didDiscoverServices");
    //错误处理
    if(error){
        NSLog(@"Discovered services for %@ with error: %@",peripheral.name, [error localizedDescription]);
        return;
    }
    
    //循环查找特性
//    for (int i=0; i < peripheral.services.count; i++) {
//        CBService *s = [peripheral.services objectAtIndex:i];
//        if ([self compareCBUUID:s.UUID UUID2:[CBUUID UUIDWithString:ISSC_SERVICE_UUID]]) {
//            NSLog(@"Fetching characteristics for service with UUID : %s\r",[self CBUUIDToString:s.UUID]);
//            [peripheral discoverCharacteristics:nil forService:s];
//        }
//    }
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:ISSC_CHAR_RX_UUID],[CBUUID UUIDWithString:ISSC_CHAR_TX_UUID]] forService:service];
    }
}

/**
    找到外设相关的特性回调函数
 */
#pragma mark 扫描到外设的特性回调
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    NSLog(@"didDiscoverCharacteristicsForService");
    if (error){
//        NSLog(@"%@ Discovered characteristics for %@ with error: %@",TAG,service.UUID, [error localizedDescription]);
        return;
    }
    
    NSLog(@"Characteristics of service with UUID : %s found\r\n",[self CBUUIDToString:service.UUID]);
    
    for(int i=0; i < service.characteristics.count; i++) {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        #pragma unused (c)
        NSLog(@"Found characteristic %s\r",[ self CBUUIDToString:c.UUID]);
    }
    if([self compareCBUUID:service.UUID UUID2:[CBUUID UUIDWithString:ISSC_SERVICE_UUID]]) {
        NSLog(@"Finished discovering characteristics\r");
        [self enableRead:self.activePeripheral];
        if([self.delegate respondsToSelector:@selector(connectedPeripheral:)]){
            [self.delegate connectedPeripheral:self.activePeripheral];
        }
        self.state = CsScaleStateConnected;
        if ([_delegate respondsToSelector:@selector(didUpdateCsScaleState:)]) {
            [_delegate didUpdateCsScaleState:CsScaleStateConnected];
        }
//        NSLog(@"向蓝牙开始下传数据.........");
        
    }
}

/**
 与外设做数据交互 读
 */
#pragma mark 连接状态下,接收到数据回调,透传
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (_delegate == nil) {
        NSLog(@"You still not initialized the delegate");
        return;
    }
    if(error){
        NSLog(@"didUpdateValueForCharacteristic");
        return;
    }
    NSLog(@"didUpdateValueForCharacteristic");
    NSString *UUIDStr = [NSString stringWithFormat:@"%@",characteristic.UUID];
    if ([ISSC_CHAR_RX_UUID isEqualToString:UUIDStr]) {
        NSLog(@"芯海-透传的数据：%@",characteristic.value);
        //发出透传连接广播
        if([_delegate respondsToSelector:@selector(afterConnectData:)]){
            [_delegate afterConnectData:characteristic.value];
        }
        Frame *frame = [[Frame alloc] initWithData:characteristic.value];
        if(frame != nil) {
            switch (frame.commandByte) {
                case 0x20: { // 同步所有单价
                    SUPRespFrame *respFrame = [[SUPRespFrame alloc] initWithData:characteristic.value];
                    if ([_delegate respondsToSelector:@selector(syncProductComplete:success:)]) {
                        [_delegate syncProductComplete:respFrame.productId success:respFrame.success];
                    }
                    break;
                }
                case 0x21: { // 同步时间
                    SyncTimeRespFrame *syncTimeRespFrame = [[SyncTimeRespFrame alloc] initWithData:characteristic.value];
                    if ([_delegate respondsToSelector:@selector(syncTimeComplete:)]) {
                        [_delegate syncTimeComplete:syncTimeRespFrame.success];
                    }
                    break;
                }
                case 0x22: {// 统计数据上传
                    StatisticDataFrame *statisticFrame = [[StatisticDataFrame alloc] initWithData:characteristic.value];
                    if ([_delegate respondsToSelector:@selector(discoverStatisticData:)]) {
                        [_delegate discoverStatisticData:statisticFrame.data];
                    }
                    break;
                }
                case 0x23:{
                    StraightFrame *straightFrame = [[StraightFrame alloc] initWithData:characteristic.value];
                    if ([_delegate respondsToSelector:@selector(discoverStraightData:)]) {
                        [_delegate discoverStraightData:straightFrame.data];
                    }
                    break;
                }
                default:
                    NSLog(@"收到的帧所带的命令字节不正确...");
                    break;
            }
        }
    }
}

#pragma mark 断开连接设备 回调
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"CsBtUtil -- >Disconnect");
    self.state = CsScaleStateOpened;
    if ([_delegate respondsToSelector:@selector(didUpdateCsScaleState:)]) {
        [_delegate didUpdateCsScaleState:CsScaleStateOpened];
    }
    if([self.delegate respondsToSelector:@selector(didDisconnectPeripheral:error:)]){
        [self.delegate didDisconnectPeripheral:peripheral error:error];
    }
}

#pragma mark - custom function
#pragma mark 开始搜索蓝牙
-(void)startScanBluetoothDevice{
    if(!self){
        return;
    }
    if (_delegate != nil) {
        if (self.state == CsScaleStateOpened) {
            self.state = CsScaleStateBroadcast;
            if ([_delegate respondsToSelector:@selector(didUpdateCsScaleState:)]) {
                [_delegate didUpdateCsScaleState:CsScaleStateBroadcast];
            }
        }
    }
    [_manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
}

-(BOOL)isOpen {
    return btIsOpen;
}


#pragma mark 停止搜索蓝牙
-(void)stopScanBluetoothDevice{
    if(_manager != nil){
        [_manager stopScan];
//        _manager = nil;
    }
}

#pragma mark 连接设备
-(BOOL)connect:(CBPeripheral *)peripheral{
    if (self.state != CsScaleStateConnecting) {
        NSLog(@"准备连接 ...");
        self.state = CsScaleStateConnecting;
        if (_delegate != nil && [_delegate respondsToSelector:@selector(didUpdateCsScaleState:)]) {
            [_delegate didUpdateCsScaleState:CsScaleStateConnecting];
        }
        [_manager connectPeripheral:peripheral
                            options:nil];
        connectMonitor = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(connectTimeout:) userInfo:peripheral repeats:NO];
    }
    return (YES);
}

-(void)connectTimeout:(NSTimer *)timer {
    if (self.state == CsScaleStateConnecting) {
        self.state = CsScaleStateOpened;
        [self connect:self.activePeripheral];
        connectMonitor = nil;
    }
}

-(void)writeFrameToPeripheral:(Frame *)frame {
    NSString *SERVICE_UUID = ISSC_SERVICE_UUID;
    NSString *TX_UUID = ISSC_CHAR_TX_UUID;
    [self writeValueWithUUID:SERVICE_UUID characteristicUUID:TX_UUID p:self.activePeripheral data:frame.frameFull];
}

/**
 使能读，这样会在通道中读取到函数
 */
#pragma mark 使能读
-(void)enableRead:(CBPeripheral*)p {
    NSString *SERVICE_UUID = ISSC_SERVICE_UUID;
    NSString *RX_UUID = ISSC_CHAR_RX_UUID;
    [self notificationWithUUID:SERVICE_UUID characteristicUUID:RX_UUID p:p on:YES];
}


/**
 写入设备到外设中
 */
#pragma mark 写信息到设备中
-(void)writeValue:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data{
    //NSLog(@"WRITE:====:%04X, %04X", serviceUUID, characteristicUUID);
    
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        //Print("Could not find service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        //Print("Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    
    //NSLog(@"PROPERTIES:%02X", characteristic.properties);
    
    CBCharacteristicWriteType writeType = CBCharacteristicWriteWithoutResponse;
    
    if (characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) {
        writeType = CBCharacteristicWriteWithoutResponse;
    }
    
    [p writeValue:data forCharacteristic:characteristic type:writeType];
}

-(void)writeValueWithUUID:(NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID p:(CBPeripheral *)p data:(NSData *)data{
    //NSLog(@"WRITE:====:%04X, %04X", serviceUUID, characteristicUUID);
    
//    UInt16 s = [self swap:serviceUUID];
//    UInt16 c = [self swap:characteristicUUID];
//    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
//    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
//    CBUUID *su = [CBUUID UUIDWithData:sd];
//    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBUUID *su = [CBUUID UUIDWithString:serviceUUID];
    CBUUID *cu = [CBUUID UUIDWithString:characteristicUUID];
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        //Print("Could not find service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        //Print("Could not find characteristic with UUID %s on service with UUID %s on peripheral with UUID %s\r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],[self UUIDToString:p.UUID]);
        return;
    }
    
    //NSLog(@"PROPERTIES:%02X", characteristic.properties);
    
    CBCharacteristicWriteType writeType = CBCharacteristicWriteWithResponse;
    
    if (characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) {
        writeType = CBCharacteristicWriteWithoutResponse;
    }
    
    [p writeValue:data forCharacteristic:characteristic type:writeType];
}



-(const char *) CBUUIDToString:(CBUUID *) UUID {
    return [[UUID.data description] cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
}


-(int) compareCBUUID:(CBUUID *) UUID1 UUID2:(CBUUID *)UUID2 {
    char b1[16];
    char b2[16];
    [UUID1.data getBytes:b1];
    [UUID2.data getBytes:b2];
    if (memcmp(b1, b2, UUID1.data.length) == 0)return 1;
    else return 0;
}


-(void)notificationWithUUID:(NSString *)serviceUUID characteristicUUID:(NSString *)characteristicUUID p:(CBPeripheral *)p on:(BOOL)on{
    //NSLog(@"NOTIFICATION:====:%04X, %04X", serviceUUID, characteristicUUID);
//    
//    UInt16 s = [self swap:serviceUUID];
//    UInt16 c = [self swap:characteristicUUID];
//    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
//    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
//    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *su = [CBUUID UUIDWithString:serviceUUID];
//    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBUUID *cu = [CBUUID UUIDWithString:characteristicUUID];
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        NSLog(@"Could not find service with UUID %s on peripheral with UUID %@\r\n",[self CBUUIDToString:su],p.identifier);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    
    // Creates the characteristic
    CBMutableCharacteristic *customCharacteristic = [[CBMutableCharacteristic alloc] initWithType:cu properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
    
    
    // Creates the service and adds the characteristic to it
    CBMutableService *customService = [[CBMutableService alloc] initWithType:su primary:YES];
    
    // Sets the characteristics for this service
    [customService setCharacteristics:@[customCharacteristic]];
    if (!characteristic) {
        NSLog(@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with name %@ \r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],p.identifier);
        return;
    }
    [p setNotifyValue:on forCharacteristic:characteristic];
}

-(void)notification:(int)serviceUUID characteristicUUID:(int)characteristicUUID p:(CBPeripheral *)p on:(BOOL)on{
    //NSLog(@"NOTIFICATION:====:%04X, %04X", serviceUUID, characteristicUUID);
    
    UInt16 s = [self swap:serviceUUID];
    UInt16 c = [self swap:characteristicUUID];
    NSData *sd = [[NSData alloc] initWithBytes:(char *)&s length:2];
    NSData *cd = [[NSData alloc] initWithBytes:(char *)&c length:2];
    CBUUID *su = [CBUUID UUIDWithData:sd];
    CBUUID *cu = [CBUUID UUIDWithData:cd];
    CBService *service = [self findServiceFromUUID:su p:p];
    if (!service) {
        NSLog(@"Could not find service with UUID %s on peripheral with UUID %@\r\n",[self CBUUIDToString:su],p.name);
        return;
    }
    CBCharacteristic *characteristic = [self findCharacteristicFromUUID:cu service:service];
    if (!characteristic) {
        NSLog(@"Could not find characteristic with UUID %s on service with UUID %s on peripheral with name %@ \r\n",[self CBUUIDToString:cu],[self CBUUIDToString:su],p.name);
        return;
    }
    [p setNotifyValue:on forCharacteristic:characteristic];
}

-(UInt16) swap:(UInt16)s {
    UInt16 temp = s << 8;
    temp |= (s >> 8);
    return temp;
}

-(CBService *) findServiceFromUUID:(CBUUID *)UUID p:(CBPeripheral *)p{
    for(int i = 0; i < p.services.count; i++) {
        CBService *s = [p.services objectAtIndex:i];
        if ([self compareCBUUID:s.UUID UUID2:UUID]){
            return s;
        }
    }
    return nil; //Service not found on this peripheral
}


-(CBCharacteristic *) findCharacteristicFromUUID:(CBUUID *)UUID service:(CBService*)service {
    for(int i=0; i < service.characteristics.count; i++) {
        CBCharacteristic *c = [service.characteristics objectAtIndex:i];
        if ([self compareCBUUID:c.UUID UUID2:UUID]) return c;
    }
    return nil; //Characteristic not found on this service
}

-(const char *) UUIDToString:(CFUUIDRef)UUID {
    if (!UUID) return "NULL";
    CFStringRef s = CFUUIDCreateString(NULL, UUID);
    return CFStringGetCStringPtr(s, 0);
    
}

-(UInt16) CBUUIDToInt:(CBUUID *) UUID {
    char b1[16];
    [UUID.data getBytes:b1];
    return ((b1[0] << 8) | b1[1]);
}

-(void)disconnectWithBt {
    if(self.activePeripheral != nil) {
        self.state = CsScaleStateOpened;
        if (_delegate != nil && [_delegate respondsToSelector:@selector(didUpdateCsScaleState:)]) {
            [_delegate didUpdateCsScaleState:CsScaleStateOpened];
        }
        [_manager cancelPeripheralConnection:self.activePeripheral];
        self.activePeripheral = nil;
    }
}


@end
