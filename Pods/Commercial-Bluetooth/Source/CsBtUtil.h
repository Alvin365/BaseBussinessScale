//
//  CsBtUtil.h
//  lib-bt
//
//  Created by mac on 15-3-16.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BleDefines.h"
#import "Frame.h"
#import "SyncUnitPriceFrame.h"
#import "TransactionDataReqFrame.h"
#import "BleDeviceDelegate.h"
#import "ReceiptsTDRespFrame.h"
#import "ResetDataReqFrame.h"

extern BOOL const pinVeryfy;

@interface CsBtUtil : NSObject <CBCentralManagerDelegate,CBPeripheralDelegate>{
    CBCentralManager *_manager;
    BOOL btIsOpen;
}

#pragma mark -单例模式获取
+(CsBtUtil *)getInstance;

#pragma mark 自定义变量
@property(strong, nonatomic) id<BleDeviceDelegate> delegate;
@property(assign, nonatomic) CsScaleState state;

@property(assign, nonatomic) BOOL stopAdvertisementState;//停止广播标志
@property(strong, nonatomic) CBPeripheral *activePeripheral; //当前透传连接设备
@property(strong, nonatomic) CBCharacteristic *readCharacteristic;//当前读特
/**
 * 蓝牙 重连5次失败的回调
 */
@property (nonatomic, copy) void (^reconnectErrorBlock)();

#pragma mark -自定义函数
#pragma mark 开始查找蓝牙设备
-(void)startScanBluetoothDevice;
#pragma mark 停止查找蓝牙设备
-(void)stopScanBluetoothDevice;

-(BOOL)connect:(CBPeripheral *)peripheral;

- (BOOL)connect:(CBPeripheral *)peripheral timeOut:(void(^)())timeOut;
/**
 *  写数据帧到蓝牙设备
 *
 *  @param frame 帧数据
 */
-(void)writeFrameToPeripheral:(Frame *)frame;
/**
 * 同步单价
 */
- (void)writeFrameToPeripheral:(Frame *)frame completedBlock:(void(^)(BOOL succeess,Byte xorValue,NSInteger errorCount))completedBlock;
/**
 * 同步历史数据
 */
- (void)writeFrameToPeripheral:(Frame *)frame historyBlock:(void(^)(NSArray *histories))historyBlock;

-(BOOL)isOpen;

-(void)disconnectWithBt;

@end
