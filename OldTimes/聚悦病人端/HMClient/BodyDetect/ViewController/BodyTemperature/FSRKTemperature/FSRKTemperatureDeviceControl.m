//
//  FSRKTemperatureDeviceControl.m
//  BlueToothDemo
//
//  Created by yinquan on 17/4/5.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "FSRKTemperatureDeviceControl.h"

@implementation FSRKTemperatureDeviceControl

- (void) controlSetup
{
    validDeviceName = [NSString stringWithFormat:@"FSRKB-EWQ01"];
    [super controlSetup];
}

- (BOOL) checkDeviceName:(CBPeripheral *)peripheral
{
    if (!validDeviceName || 0 == validDeviceName.length) {
        return NO;
    }
    
    if (peripheral.name && peripheral.name.length > 0)
    {
        NSString* name = peripheral.name;
        if ([name isEqualToString:validDeviceName])
        {
            return YES;
        }
        
    }
    return NO;
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services)
    {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:@"1910"]])
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
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF2"]])
        {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            [peripheral readValueForCharacteristic:characteristic];
        }
        
    }
}


//当设备有数据返回时，系统调用这个方法
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF2"]])
    {
        return;
    }
    
    NSData *valueData = characteristic.value;
    
    [self makeTemperature:valueData];
}

//处理体温数据
- (void) makeTemperature:(NSData*) valueData
{
    if (!valueData || valueData.length != 13)
    {
        return;
        //读取提问数据失败
//        if (self.resultdelegate && [self.resultdelegate respondsToSelector:@selector(temperature:error:)])
//        {
//            [self.resultdelegate temperature:0 error:Error_DataError];
//        }
//        return;
    }
    
    NSData* headerData = [valueData subdataWithRange:NSMakeRange(0, 4)];
    NSString* headerDataString = [headerData hexString];
    
    if (![headerDataString isEqualToString:@"0220DD08"])
    {
        //不是正常体温数据
        if (self.resultdelegate && [self.resultdelegate respondsToSelector:@selector(temperature:error:)])
        {
            [self.resultdelegate temperature:0 error:Error_DataError];
        }
        return;
    }
    
    NSData* flagData = [valueData subdataWithRange:NSMakeRange(4, 1)];
    NSString* flagDataString = [flagData hexString];

    if (![flagDataString isEqualToString:@"FF"])
    {
        //不是正常体温数据
        if (self.resultdelegate && [self.resultdelegate respondsToSelector:@selector(temperature:error:)])
        {
            [self.resultdelegate temperature:0 error:Error_DataError];
        }
        return;
    }
    
    NSData* tempHData = [valueData subdataWithRange:NSMakeRange(5, 1)];
    NSString* tempHDataString = [tempHData hexString];
    
    if ([tempHDataString isEqualToString:@"EE"])
    {
        NSData* errorData = [valueData subdataWithRange:NSMakeRange(6, 1)];
        NSString* errorDataString = [errorData hexString];
        NSLog(@"errorDataString = %@", errorDataString);
        const char* errorPtr = [errorData bytes];
        int8_t erroCodeInt8 = (int8_t)(*errorPtr);
        NSLog(@"erroCode = %d", erroCodeInt8);
        NSInteger deviceError = (NSInteger)erroCodeInt8;
        //设备出错
        if (self.resultdelegate && [self.resultdelegate respondsToSelector:@selector(temperature:error:deviceError:)])
        {
            [self.resultdelegate temperature:0 error:Error_DeviceError deviceError:deviceError];
        }
        return;
    }
    
    NSData* tempData = [valueData subdataWithRange:NSMakeRange(5, 2)];
//    NSString* tempDataString = [tempData hexString];
//    NSLog(@"tempDataString %@", tempDataString);
    const char* tempDataPtr = [tempData bytes];
    int tempValueInt;
    Byte* tempValuePtr = (Byte*)&tempValueInt;
    tempValuePtr[0] = tempDataPtr[1];
    tempValuePtr[1] = tempDataPtr[0];
    
    CGFloat tempValue = tempValueInt;
    tempValue /= 10;
    
    if (self.resultdelegate && [self.resultdelegate respondsToSelector:@selector(temperature:error:)])
    {
        [self.resultdelegate temperature:tempValue error:Error_None];
    }
}
@end
