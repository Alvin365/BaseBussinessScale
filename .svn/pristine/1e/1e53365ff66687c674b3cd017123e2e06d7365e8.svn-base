//
//  BleDeviceDelegate.h
//  CsBtUtil
//
//  Created by ChipSea on 15/12/26.
//  Copyright © 2015年 chipsea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BroadcastData.h"
#import "StraightData.h"
#import "StatisticData.h"

///==========================设备状态============================
typedef NS_ENUM(NSInteger, CsScaleState) {
    CsScaleStateOpened          = 40000, //打开未连接
    CsScaleStateClosed          = 40001, //关闭
    CsScaleStateBroadcast       = 40002, //接受广播中
    CsScaleStateConnecting      = 40003,//正在连接
    CsScaleStateConnected       = 40004,// 连接上了
    CsScaleStateCalculating     = 40005, // 透传建立后,且秤上有数据
    CsScaleStateWaitCalculat    = 40006// 透传建立后,且秤上午数据
};


///==========================设备代理==========================
@protocol BleDeviceDelegate <NSObject>


/**
 *  发现广播数据
 *
 *  @param data 广播数据
 */
-(void)discoverBroadcastData:(BroadcastData *)data fromPeripheral:(CBPeripheral *)peripheral;

/**
 *  发现透传数据
 *
 *  @param data 透传数据
 */
-(void)discoverStraightData:(StraightData *)data;

/**
 *  连接设备成功的回调
 *
 *  @param peripheral 连接成功的设备
 */
-(void)connectedPeripheral:(CBPeripheral *)peripheral;


/**
 *  断开设备的回调
 *
 *  @param peripheral 断开的设备
 *  @param error      错误信息
 */
-(void)didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error;

@optional

/**
 *  蓝牙状态发生变化的回调
 *
 *  @param state 蓝牙状态
 */
-(void)didUpdateCsScaleState:(CsScaleState)state;

/**
 *  获得广播数据(未解析)
 *
 *  @param data 广播数据
 */
-(void)currentAdvertisementData:(NSData *)data;

/**
 透传连接后，透传数据(未解析)
 */
-(void)afterConnectData:(NSData *)data;

/**
 *  发现统计数据
 *
 *  @param data 统计数据
 */
-(void)discoverStatisticData:(StatisticData *)data;

/**
 *  同步时间完成的huidiao
 *
 *  @param success 是否成功,成功为YES
 */
-(void)syncTimeComplete:(BOOL)success;

/**
 *  同步单价信息
 *
 *  @param productId 产品代号
 *  @param success   是否成功,成功为YES
 */
-(void)syncProductComplete:(int)productId success:(BOOL)success;

@end
