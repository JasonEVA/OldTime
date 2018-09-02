//
//  U80LHBloodPressureBLEDevice.m
//  HMClient
//
//  Created by lkl on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "U80LHBloodPressureBLEDevice.h"

@interface U80LHBloodPressureBLEDevice ()

@end

@implementation U80LHBloodPressureBLEDevice

//设备名称
- (BOOL)checkDeviceName:(NSString*) deviceName{
    if (!deviceName || deviceName.length == 0)
    {
        return NO;
    }
    return [deviceName isEqualToString:@"Bluetooth BP"];
}

//服务
- (BOOL)checkDeviceService:(CBService *)service{
    if (!service) {
        return NO;
    }
    return [service.UUID isEqual:[CBUUID UUIDWithString:@"FFF0"]];
}

//读特征
- (BOOL)checkNotifyingCharacteristics:(CBCharacteristic *)characteristic{
    if (!characteristic) {
        return NO;
    }
    return [characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF1"]];
}

//写特征
- (BOOL)checkWriteCharacteristic:(CBCharacteristic *)characteristic{
    if (!characteristic) {
        return NO;
    }
    return [characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF2"]];
}

- (void)parseReceiveData:(NSData *)valueData
{
    Byte *resultByte = (Byte *)[valueData bytes];
    
    id<U80LHBloodPressureDelegate> U80HDelegate = (id<U80LHBloodPressureDelegate>) self.bluetoothDelegate;
    
    if (0xFB == resultByte[2])
    {
        self.diaRecord = [NSString stringWithFormat:@"%d",resultByte[4]];
//        [self setValue:[NSString stringWithString:self.diaRecord] forKey:@"diaRecord"];
        if (U80HDelegate && [U80HDelegate respondsToSelector:@selector(detectingPressure:)]) {
            [U80HDelegate detectingPressure:resultByte[4]];
        }
        
    }else if (0xFC == resultByte[2])
    {
        //测试结果
        NSLog(@"测试结果 %d %d %d",resultByte[3],resultByte[4],resultByte[5]);
        if (_pressureResult){
            return;
        }
        
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        [dicResult setValue:[NSNumber numberWithInteger:resultByte[3]]forKey:@"SSY"];
        [dicResult setValue:[NSNumber numberWithInteger:resultByte[4]]forKey:@"SZY"];
        [dicResult setValue:[NSNumber numberWithInteger:resultByte[5]]forKey:@"XL_OF_XY"];
        
        if (U80HDelegate && [U80HDelegate respondsToSelector:@selector(detectedWithDictionary:)])
        {
            [U80HDelegate detectedWithDictionary:dicResult];
        }
    }else
    {
        //异常
        if (U80HDelegate && [U80HDelegate respondsToSelector:@selector(measureBloodPressureError:)]) {
            [U80HDelegate measureBloodPressureError:resultByte[3]];
        }
    }
}

@end
