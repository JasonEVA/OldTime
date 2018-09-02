//
//  HellofitECGBLEDevice.m
//  HMClient
//
//  Created by lkl on 16/4/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HellofitECGBLEDevice.h"
#import "BodyDetectSysConvertUtil.h"

@implementation HellofitECGBLEDevice

//设备名称
- (BOOL)checkDeviceName:(NSString*) deviceName{
    if (!deviceName || deviceName.length == 0)
    {
        return NO;
    }
    return [deviceName isEqualToString:@"HFHN101000"];
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
    return [characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF7"]];
}

//写特征
- (BOOL)checkWriteCharacteristic:(CBCharacteristic *)characteristic{
    if (!characteristic) {
        return NO;
    }
    return [characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF6"]];
}

//发送命令
- (NSData *)sendCommand{
    return [BodyDetectSysConvertUtil dataByteHexString:@"FF0000"];
}

- (void)parseReceiveData:(NSData *)valueData{
    
    self.ECGResultdelegate = (id<ECGBluetoothControlResultDelegate>)self.bluetoothDelegate;
    if ([self.ECGResultdelegate respondsToSelector:@selector(measureECGSuccessWithDecodeData:)]){
        //测量数据
        [self.ECGResultdelegate measureECGSuccessWithDecodeData:valueData];
    }
}

@end
