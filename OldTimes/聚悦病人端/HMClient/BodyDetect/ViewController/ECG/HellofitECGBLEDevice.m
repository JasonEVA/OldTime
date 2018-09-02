//
//  HellofitECGBLEDevice.m
//  HMClient
//
//  Created by lkl on 16/4/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HellofitECGBLEDevice.h"
#import "SysConvertUtil.h"

@implementation HellofitECGBLEDevice

- (void) controlSetup
{
    validDeviceName = [NSString stringWithFormat:@"HFHN101000"];
    [super controlSetup];
}

#pragma mark - 设置代理
//  当外设发现服务的时候,会调用该方法
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        return;
    }
    
    for (CBService *service in peripheral.services)
    {
        if([service.UUID isEqual:[CBUUID UUIDWithString:@"FFF0"]])
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
    if (error){
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF7"]])
        {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            [peripheral readValueForCharacteristic:characteristic];
        }
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF6"]])
        {
            self.characteristic = characteristic;
            
            //连接成功，发送握手命令(需延时才能握手成功)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1/*延迟执行时间*/ * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self writeDate:[SysConvertUtil dataByteHexString:@"FF0000"]];
            });
            
        }
    }
}

//当设备有数据返回时，系统调用这个方法
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
    NSData *valueData = characteristic.value;
    if (!valueData || error)
    {
        return;
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF7"]])
    {
        //[self decodeData:valueData];
        if ([self.ECGResultdelegate respondsToSelector:@selector(measureECGSuccessWithDecodeData:)])
        {
            //测量数据
            [self.ECGResultdelegate measureECGSuccessWithDecodeData:valueData];
        }
    }
}

//解析数据
//- (void)decodeData:(NSData *)valueData
//{
//    Byte *bytes = (Byte *)valueData.bytes;
//    
//    int dataLen = bytes[0]& 0xFF;
//    if (dataLen == 19)
//    {
//        int sensorState = bytes[dataLen-6]&0xFF;
//        if (sensorState == 200)
//        {
//            //接触
//            //NSLog(@"%@",valueData);
//            int ecgDataEndPos = dataLen - 6;
//            if (!_measureECGValueArray)
//            {
//                self.measureECGValueArray = [[NSMutableArray alloc] init];
//            }
//            for (int i = 1; i<ecgDataEndPos; i=i+2)
//            {
//                int valueInt = [self signedWithValue:(bytes[i+1]&0xFF)+((bytes[i]&0xFF)<<8) length:16];
//                
//                //四舍五入为最近的整数
//                [self.measureECGValueArray addObject:[NSNumber numberWithInt:-round(valueInt*0.143f)]];
//            }
//            
//            if ([self.ECGResultdelegate respondsToSelector:@selector(measureECGSuccessWithPointsArray:)])
//            {
//                //测量数据
//                [self.ECGResultdelegate measureECGSuccessWithPointsArray:self.measureECGValueArray];
//            }
//        }
//        if (sensorState==0)
//        {
//            //停止测量
//            if ([self.ECGResultdelegate respondsToSelector:@selector(measureECGSuccessWithPointsArray:)])
//            {
//                [self.ECGResultdelegate measureECGStop];
//            }
//        }
//    }
//    
//}

//-(int)signedWithValue:(int)value length:(int)length
//{
//    if ((value &1<<(length-1))!=0)
//    {
//        value = -1 * ((1 << (length - 1)) - (value & (1 << (length - 1)) - 1));
//    }
//    return value;
//}

@end
