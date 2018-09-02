//
//  YuwellBloodSugarBleDeviceControl.m
//  HMClient
//
//  Created by yinquan on 2017/6/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "YuwellBloodSugarBleDeviceControl.h"

@implementation YuwellBloodSugarBleDeviceControl

- (void) controlSetup
{
    validDeviceName = [NSString stringWithFormat:@"Yuwell Glucose"];
    [super controlSetup];
}

#pragma mark - 设置代理
//  当外设发现服务的时候,会调用该方法
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services)
    {
        if([service.UUID isEqual:[CBUUID UUIDWithString:@"1808"]])
        {
            [self.centralManager stopScan];
            if ([self.timer isValid])
            {
                [self.timer invalidate];
            }
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

//  当外设发现某个服务的特征的时候会调用该方法
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2a18"]])
        {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            [peripheral readValueForCharacteristic:characteristic];
            self.characteristic = characteristic;
        }
        
    }
}

//当设备有数据返回时，系统调用这个方法
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2a18"]])
    {
        if (characteristic.value == NULL || error)
        {
            return;
        }
        
        NSData *valueData = characteristic.value;
        if (valueData && valueData.length > 0) {
            //处理蓝牙设备返回的数据
            [self paraserResultData:valueData];
        }

    }
}

- (void) paraserResultData:(NSData*) valueData
{
    if (!valueData || valueData.length < 13) {
        return;
    }
    
    NSLog(@"paraserResultData len = %ld", valueData.length);
    
    NSLog(@"paraserResultData resultData %@", [valueData hexString]);
    
    NSData* flagData = [valueData subdataWithRange:NSMakeRange(0, 1)];
    UInt8 flag = 0;
    BytePtr flagBytePtr = (BytePtr)flagData.bytes;
    flag = *flagBytePtr;
    
    if (0 == (flag | 0x04)) {
        //不是正常的数据
        return;
    }
    
    NSData* glucoseData = [valueData subdataWithRange:NSMakeRange(10, 2)];
    
    UInt16* glucoseBytePtr = (UInt16*)glucoseData.bytes;
    NSInteger glucoseInt16 = *glucoseBytePtr;
    
    NSInteger expunit = (glucoseInt16 & 0xF000) >> 12;
    NSInteger glucose = glucoseInt16 & 0x0FFF;
    
    float glucoseValue = glucose * pow(10, (expunit - 13));
    
    NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
    
    [dicResult setValue:[NSNumber numberWithFloat:glucoseValue] forKey:@"XT_SUB"];
    
    [self setBloodSugarResult:dicResult];
}


@end
