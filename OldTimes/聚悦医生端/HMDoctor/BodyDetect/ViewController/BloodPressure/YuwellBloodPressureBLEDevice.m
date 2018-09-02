//
//  YuwellBloodPressureBLEDevice.m
//  BleTest
//
//  Created by lkl on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "YuwellBloodPressureBLEDevice.h"

@implementation BloodPressureRetModel

@end

@implementation YuwellBloodPressureBLEDevice

//设备名称
- (BOOL)checkDeviceName:(NSString*) deviceName{
    if (!deviceName || deviceName.length == 0){
        return NO;
    }
    
    if ([deviceName isEqualToString:@"Yuwell BloodPressure"] || [deviceName isEqualToString:@"Yuwell BP-YE680A"]) {
        return YES;
    }
    return NO;
}

//服务
- (BOOL)checkDeviceService:(CBService *)service{
    if (!service) {
        return NO;
    }
    return [service.UUID isEqual:[CBUUID UUIDWithString:@"1810"]];
}

//读特征
- (BOOL)checkNotifyingCharacteristics:(CBCharacteristic *)characteristic{
    if (!characteristic) {
        return NO;
    }
    return ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A35"]] || [characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A36"]]);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSData *valueData = characteristic.value;
    if (!valueData || valueData.length == 0) {
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A36"]]) {
        //正在测量中
        [self paraserDetectingData:valueData];
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A35"]])
    {
        //测量结束，分析数据
        [self paraserResultData:valueData];
        return;
    }
}

- (void) paraserDetectingData:(NSData*) data
{
    if (!data || data.length == 0) {
        return;
    }
    
//    NSLog(@"YuwellBloodPressureBluUtil::paraserDetectingData %@", [data hexString]);
    
    NSInteger detectPressure = [self parserDetectingPressure:data];
    id<YuwellBloodPressureBluUtilDelegate> yuwellDelegate = (id<YuwellBloodPressureBluUtilDelegate>) self.bluetoothDelegate;
    if (yuwellDelegate && [yuwellDelegate respondsToSelector:@selector(detectingPressure:)])
    {
        [yuwellDelegate detectingPressure:detectPressure];
    }
}

- (void) paraserResultData:(NSData*) data
{
    if (!data || data.length == 0) {
        return;
    }
    //NSLog(@"YuwellBloodPressureBluUtil::paraserResultData %@", [data hexString]);
    
    BloodPressureRetModel* retModel = [self parserBloodPressure:data];
    id<YuwellBloodPressureBluUtilDelegate> yuwellDelegate = (id<YuwellBloodPressureBluUtilDelegate>) self.bluetoothDelegate;
    if (yuwellDelegate && [yuwellDelegate respondsToSelector:@selector(detectedsystolic:diastolic:heartRate:)])
    {
        [yuwellDelegate detectedsystolic:retModel.systolic diastolic:retModel.diastolic heartRate:retModel.heartRate];
    }
}

- (NSInteger) parserDetectingPressure:(NSData*) data
{
    if (!data || data.length == 0) {
        return 0;
    }
    
    NSData* systolicData = [data subdataWithRange:NSMakeRange(1, 2)];
    
    int16_t systolicInt16;
    [systolicData getBytes: &systolicInt16 length:sizeof(systolicInt16)];
    
    
    return (NSInteger) systolicInt16;
}

- (BloodPressureRetModel*) parserBloodPressure:(NSData*) data
{
    if (!data || data.length == 0) {
        return nil;
    }
    
    BloodPressureRetModel* retModel = [[BloodPressureRetModel alloc]init];
    //收缩压
    NSData* systolicData = [data subdataWithRange:NSMakeRange(1, 2)];
    NSLog(@"systolicData data %@", [systolicData hexString]);
    int16_t systolicInt16;
    [systolicData getBytes: &systolicInt16 length:sizeof(systolicInt16)];
    NSLog(@"systolicInt16 = %d", systolicInt16);
    retModel.systolic = systolicInt16;
    
    //舒张压
    NSData* diastolicData = [data subdataWithRange:NSMakeRange(3, 2)];
    NSLog(@"diastolicData data %@", [diastolicData hexString]);
    int16_t diastolicInt16;
    [diastolicData getBytes: &diastolicInt16 length:sizeof(diastolicInt16)];
    NSLog(@"diastolicInt16 = %d", diastolicInt16);
    retModel.diastolic = diastolicInt16;
    
    NSData* rateData = [data subdataWithRange:NSMakeRange(14, 2)];
    NSLog(@"rateData data %@", [rateData hexString]);
    int16_t rateInt16;
    [rateData getBytes: &rateInt16 length:sizeof(rateInt16)];
    NSLog(@"rateInt16 = %d", rateInt16);
    retModel.heartRate = rateInt16;
    
    return retModel;
}


@end
