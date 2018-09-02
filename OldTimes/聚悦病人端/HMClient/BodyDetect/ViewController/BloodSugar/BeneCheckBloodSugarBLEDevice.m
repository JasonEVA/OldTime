//
//  BeneCheckBloodSugarBLEDevice.m
//  HMClient
//
//  Created by lkl on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BeneCheckBloodSugarBLEDevice.h"

@implementation BeneCheckBloodSugarBLEDevice

- (void) controlSetup
{
    validDeviceName = [NSString stringWithFormat:@"BeneCheck-"];
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
        if ([name hasPrefix:@"BeneCheck-"])
        {
            return YES;
        }
        
    }
    return NO;
}

/*- (BOOL) checkDeviceName:(CBPeripheral *)peripheral
{
    if (!validDeviceName || 0 == validDeviceName.length) {
        return NO;
    }
    
    if (peripheral.name && peripheral.name.length > 0)
    {
        NSString* name = peripheral.name;
        if (![name hasPrefix:@"BeneCheck-"]) {
            return NO;
        }
        NSRange range = [name rangeOfString:@"BeneCheck-"];
        if (NSNotFound == range.location) {
            return NO;
        }
        
        NSString* subname = [name substringFromIndex:range.location + range.length];
        
        NSString *regex = @"^[0-9]{4}$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        BOOL isValid = [predicate evaluateWithObject:subname];
        return isValid;
    }
    
    return NO;
}*/

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
        }
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A52"]])
        {
            self.characteristic = characteristic;
        }
    }
}

//当设备有数据返回时，系统调用这个方法
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2a18"]])
    {
        //064100df 070c0202 331c0080 11
        //NSLog(@"收到蓝牙发来的数据：%@",characteristic.value);
        
        if (characteristic.value == NULL || error)
        {
            return;
        }
        
        NSString *value = characteristic.value.description;
        NSString *endValue = [value substringWithRange:NSMakeRange(23,2)];
        NSString *startValue = [value substringWithRange:NSMakeRange(26, 1)];
        NSString *valueStr = [NSString stringWithFormat:@"%@%@",startValue,endValue];
        
        NSString *flag = [value substringWithRange:NSMakeRange(25,1)];
        CGFloat f = strtoul([valueStr UTF8String], 0, 16);
        CGFloat valuef;
        if ([flag isEqualToString:@"a"])
        {
            valuef = f/1000;
        }
        else if ([flag isEqualToString:@"b"])
        {
            valuef = f/100;
        }else
        {
            [self setDevicesState:Measurement_Results];
            
            return;
        }
        
        if (_bloodSugarResult)
        {
            return;
        }
        
        NSLog(@"--%f",valuef);
        
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        
        [dicResult setValue:[NSNumber numberWithFloat:valuef]forKey:@"XT_SUB"];
        
        [self setBloodSugarResult:dicResult];
        
    }
}

- (void) showAlertMessage:(NSString*) msg
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)writeDate:(NSData *)data
{
    _bloodSugarResult = nil;
    [super writeDate:data];
}


@end
