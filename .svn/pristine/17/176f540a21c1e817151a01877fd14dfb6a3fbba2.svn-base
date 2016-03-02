//
//  BleDeviceDelegate.h
//  CsBtUtil
//
//  Created by ChipSea on 15/12/26.
//  Copyright © 2015年 chipsea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BroadcastData.h"
#import "TransactionData.h"
#import "TransactionData.h"

///==========================设备状态============================
typedef NS_ENUM(NSInteger, CsScaleState) {
    CsScaleStateOpened          = 40000, //打开未连接
    CsScaleStateClosed          = 40001, //关闭
    CsScaleStateBroadcast       = 40002, //接受广播中
    CsScaleStateConnecting      = 40003,//正在连接
    CsScaleStateConnected       = 40004,// 连接上了
    CsScaleStateCalculating     = 40005, // 透传建立后,且秤上有数据
    CsScaleStateWaitCalculat    = 40006 ,// 透传建立后,且秤上午数据
    CsScaleStateShakeHandSuccess       = 40007 ,// 握手成功
    CsScaleStateShakeHandSuccessFailure       = 40008 // 握手失败
};


///==========================设备代理==========================
@protocol BleDeviceDelegate <NSObject>

@optional
/**
 *  发现广播数据
 *
 *  @param data 广播数据
 */
-(void)discoverBroadcastData:(BroadcastData *)data fromPeripheral:(CBPeripheral *)peripheral;
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

/**
 *  完成握手机制
 *
 *  @param success 是否握手成功
 */
-(void)didHandShakeComplete:(BOOL) success;

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
 *  发现交易记录数据
 *  用于被动收款的场景、即秤端算好价格App来付款
 *
 *  @param data 交易记录数据
 */
-(void)discoverTransactionDatas:(NSMutableArray *)datas;

/**
 *  使用现金付款
 */
-(void)cashPayment;

/**
 *  取消交易
 */
-(void)cancelPayment;

/**
 *  完成称重,并获得称重记录
 *  用于主动收款的产假、即秤端秤好数据后上传给App，具体价格由App定义
 *
 *  @param data 称量好的数据
 */
-(void)finishWeighing:(TransactionData *)data;

/**
 *  发现离线交易记录
 *
 *  @param data 离线交易记录
 */
-(void)discoverOfflineDatas:(NSMutableArray *)datas;

/**
 *  秤端没有离线交易数据
 */
-(void)noOfflineData;

/**
 *  同步单价信息
 *
 *  @param xorValue  秤端收到数据的异或值得(目前暂时不用)
 *  @param success   是否成功,成功为YES
 */
-(void)syncProductComplete:(Byte)xorValue success:(BOOL)success;

/**
 *  商务秤的清除数据的应答
 */
-(void)didResetData;

@end
