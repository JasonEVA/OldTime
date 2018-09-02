//
//  JYBluetoothManager.h
//  HMDoctor
//
//  Created by lkl on 2017/8/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <CoreBluetooth/CoreBluetooth.h>
#import "JYBluetoothManagerDelegate.h"
#import "ByteHexString.h"

@interface JYBluetoothManager : NSObject <CBCentralManagerDelegate,CBPeripheralDelegate>

/** 单例方法*/
//+ (instancetype)sharedInstance;

- (id) initWithDelegate:(id<JYBluetoothManagerDelegate>) delegate;

@property(nonatomic, assign, readonly) BLEStatus currentCentralManagerState;
@property (nonatomic, weak) id <JYBluetoothManagerDelegate>bluetoothDelegate;
@property (nonatomic, assign) NSInteger scanTimeOut;      //扫描超时时间，0 － 没有超时限制

/**  蓝牙开始、停止扫描操作*/
//开始扫描
-(void)startScanning;
//停止扫描
-(void)stopScanning;
//连接超时
- (void)scanerTimeOut;
//扫描复位
-(void)resetScanning;

- (void)cleanup;

- (void)writeDate:(NSData *)data;

-(void)disConnectPeripheral;

@end
