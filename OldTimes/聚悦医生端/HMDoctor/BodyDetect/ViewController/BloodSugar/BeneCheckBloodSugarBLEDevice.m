//
//  BeneCheckBloodSugarBLEDevice.m
//  HMClient
//
//  Created by lkl on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BeneCheckBloodSugarBLEDevice.h"

@implementation BeneCheckBloodSugarBLEDevice

//设备名称
- (BOOL)checkDeviceName:(NSString*) deviceName{
    if (!deviceName || deviceName.length == 0){
        return NO;
    }
    
    if ([deviceName hasPrefix:@"BeneCheck-"]){
        return YES;
    }
    return NO;
}

//服务
- (BOOL)checkDeviceService:(CBService *)service{
    if (!service) {
        return NO;
    }
    return [service.UUID isEqual:[CBUUID UUIDWithString:@"1808"]];
}

//读特征
- (BOOL)checkNotifyingCharacteristics:(CBCharacteristic *)characteristic{
    if (!characteristic) {
        return NO;
    }
    return [characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2a18"]];
}

//写特征
- (BOOL)checkWriteCharacteristic:(CBCharacteristic *)characteristic{
    if (!characteristic) {
        return NO;
    }
    return [characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A52"]];
}


- (void)parseReceiveData:(NSData *)valueData{
    
    NSString *value = valueData.description;
    NSString *endValue = [value substringWithRange:NSMakeRange(23,2)];
    NSString *startValue = [value substringWithRange:NSMakeRange(26, 1)];
    NSString *valueStr = [NSString stringWithFormat:@"%@%@",startValue,endValue];
    
    NSString *flag = [value substringWithRange:NSMakeRange(25,1)];
    CGFloat f = strtoul([valueStr UTF8String], 0, 16);
    
    id <BeneCheckBloodSugarBLEDelegate> beneCheckBLEDelegate = (id<BeneCheckBloodSugarBLEDelegate>)self.bluetoothDelegate;
    
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
        if (beneCheckBLEDelegate && [beneCheckBLEDelegate respondsToSelector:@selector(detectBloodSugarError)]) {
            [beneCheckBLEDelegate detectBloodSugarError];
        }
        //[self setDevicesState:Measurement_Results];
        return;
    }
    
//    if (_bloodSugarResult)
//    {
//        return;
//    }
    
    NSLog(@"--%f",valuef);
    
//    NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
//    
//    [dicResult setValue:[NSNumber numberWithFloat:valuef]forKey:@"XT_SUB"];
    
//    [self setBloodSugarResult:dicResult];
    if (beneCheckBLEDelegate && [beneCheckBLEDelegate respondsToSelector:@selector(detectBloodSugarValue:)]) {
        [beneCheckBLEDelegate detectBloodSugarValue:valuef];
    }
}

@end
