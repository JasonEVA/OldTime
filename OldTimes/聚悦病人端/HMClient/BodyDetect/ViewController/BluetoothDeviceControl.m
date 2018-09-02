//
//  BluetoothDeviceControl.m
//  HMClient
//
//  Created by lkl on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BluetoothDeviceControl.h"
#import "DeviceDefine.h"

@implementation BluetoothDeviceControl

- (void) showAlertMessage:(NSString*) msg
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void) controlSetup
{
    if (!_centralManager)
    {
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state)
    {
        case CBCentralManagerStatePoweredOn:
        {
            NSLog(@"蓝牙处于开启状态！");
            [self setDevicesState:CentralManager_PoweredON];
        }
            break;
            
        case CBCentralManagerStatePoweredOff:
        {
            NSLog(@"请开启蓝牙");
            [self setDevicesState:CentralManager_PoweredOFF];
        }
            break;
            
        default:
            break;
    }
}

//超时处理
- (void)connectPeripheralsTimeout:(int)sec
{
    //isScanning iOS以后可用
    if ([self.centralManager isScanning] && IOS_VERSION_9_OR_ABOVE){
        return;
    }
    
    if (sec > 0) {     //启动定时器
        if (self.timer) {
            [self.timer invalidate];
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:sec target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
    }
    [self.centralManager scanForPeripheralsWithServices:nil options:0];
}

- (void)scanTimer:(NSTimer *)timer{
    NSLog(@"搜索不到可匹配的设备");
    
    [self.centralManager stopScan];
    [timer invalidate];
    
//    [self showAlertMessage:@"设备连接失败，您可以手动上传数据,或者重新测量"];
    
    [self setDevicesState:CentralManager_ConnectTimeOut];
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"%@",peripheral.name);
    
    if (![self checkDeviceName:peripheral]) {
        return;
    }
    /*
     if (!validDeviceName || 0 == validDeviceName.length) {
     return;
     }
     if (peripheral.name && peripheral.name.length > 0 && [peripheral.name isEqualToString:validDeviceName])
     {
     
     }
     */
    [self dealConnection:peripheral];
    return;
}

- (BOOL) checkDeviceName:(CBPeripheral *)peripheral
{
    if (!validDeviceName || 0 == validDeviceName.length) {
        return NO;
    }
    if (peripheral.name && peripheral.name.length > 0 && [peripheral.name isEqualToString:validDeviceName])
    {
        return YES;
        //[self dealConnection:peripheral];
    }
    return NO;
}

- (void) writeDate:(NSData*) data
{
    if (!data || 0 == data.length)
    {
        //没有写的数据
        return ;
    }
    if (self.connectingPeripheral)
    {
        
        [self.connectingPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
    }
}


- (void) dealConnection:(CBPeripheral*) peripheral
{
    self.connectingPeripheral = peripheral;
    [_centralManager connectPeripheral:self.connectingPeripheral options:nil];
}

-  (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"%@ 连接成功！",peripheral.name);
    
    //停止时钟
    [self.timer invalidate];

    [self setDevicesState:CentralManager_ConnectSussess];
    
    peripheral.delegate = self;
    
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@",peripheral);
    NSLog(@"%@",error);
}

/*- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
 {
 //[_centralManager connectPeripheral:peripheral options:nil];
 }*/

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    //[super centralManager:central didDisconnectPeripheral:peripheral error:error];
    detectstarted = NO;
    [self setDevicesState:CentralManager_Disconnect];
    if (self.timer)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
    //[_centralManager connectPeripheral:peripheral options:nil];
}

//用于检测中心向外设写数据是否成功
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"=======%@",error.userInfo);
    }else{
        NSLog(@"发送数据成功");
    }
}

//停止扫描并断开连接
-(void)disConnectPeripheral
{
    if ([_timer isValid])
    {
        [_timer invalidate];
        _timer = nil;
    }
    if (self.centralManager)
    {
        [_centralManager stopScan];
    }
    
    if (_connectingPeripheral != nil) {
        [_centralManager cancelPeripheralConnection:_connectingPeripheral];
    }
}


@end
