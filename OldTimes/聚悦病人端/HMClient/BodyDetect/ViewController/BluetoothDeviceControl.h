//
//  BluetoothDeviceControl.h
//  HMClient
//
//  Created by lkl on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <corebluetooth/CBService.h>
#import "BMOximeterParams.h"

typedef enum : NSInteger
{
    CentralManager_PoweredOFF,
    CentralManager_PoweredON,
    CentralManager_ConnectTimeOut,
    CentralManager_ConnectSussess,
    CentralManager_Disconnect,
    
    Measurement_Results,
    
}BluetoothControlStatus;


@interface BluetoothDeviceControl : NSObject<CBCentralManagerDelegate,CBPeripheralDelegate>

{
    NSString* validDeviceName;
    BOOL detectstarted;
}

@property (nonatomic,strong) NSTimer          *timer;
@property (nonatomic,strong) NSMutableArray   *devicesArray;
@property (nonatomic,strong) CBCentralManager *centralManager;
@property (nonatomic,strong) CBPeripheral     *connectingPeripheral;
@property (nonatomic,strong) CBCharacteristic *characteristic;
@property (nonatomic,assign) int              devicesState;

- (void)controlSetup;

- (void)connectPeripheralsTimeout:(int)sec;

- (void) writeDate:(NSData*) data;

-(void)disConnectPeripheral;  //主动断开设备
@end

