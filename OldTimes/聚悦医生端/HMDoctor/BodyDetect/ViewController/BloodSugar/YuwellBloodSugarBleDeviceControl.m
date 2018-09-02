//
//  YuwellBloodSugarBleDeviceControl.m
//  HMClient
//
//  Created by yinquan on 2017/6/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "YuwellBloodSugarBleDeviceControl.h"

@implementation YuwellBloodSugarBleDeviceControl

//设备名称
- (BOOL)checkDeviceName:(NSString*) deviceName{
    if (!deviceName || deviceName.length == 0)
    {
        return NO;
    }
    return [deviceName isEqualToString:@"Yuwell Glucose"];
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
    
//    NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
//    
//    [dicResult setValue:[NSNumber numberWithFloat:glucoseValue] forKey:@"XT_SUB"];
    
//    [self setBloodSugarResult:dicResult];
    id <YuwellBloodBloodSugarBLEDelegate> YuwellBloodBLEDelegate = (id<YuwellBloodBloodSugarBLEDelegate>)self.bluetoothDelegate;
    if (YuwellBloodBLEDelegate && [YuwellBloodBLEDelegate respondsToSelector:@selector(detectBloodSugarValue:)]) {
        [YuwellBloodBLEDelegate detectBloodSugarValue:glucoseValue];
    }
}


@end
