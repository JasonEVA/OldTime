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

- (void) showAlertMessage:(NSString*) msg
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void) controlSetup
{
    validDeviceName = [NSString stringWithFormat:@"Bluetooth BP"];
    
    [super controlSetup];
}

- (void) writeDate:(NSData*) data
{
    _pressureResult = nil;
    [super writeDate:data];
}

#pragma mark - 设置代理
//  当外设发现服务的时候,会调用该方法
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
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
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF2"]])
        {
            self.characteristic = characteristic;
        }
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF1"]])
        {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            [peripheral readValueForCharacteristic:characteristic];
        }
    }
}

//当设备有数据返回时，系统调用这个方法
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSData *adata = characteristic.value;
    if (!adata || error)
    {
        return;
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF1"]])
    {
        [self decodeData:adata];
    }
}

- (void)decodeData:(NSData *)adata
{
    Byte *resultByte = (Byte *)[adata bytes];
    
    if (0xFB == resultByte[2])
    {
        //测量中
        detectstarted = YES;
        self.diaRecord = [NSString stringWithFormat:@"%d",resultByte[4]];
        [self setValue:[NSString stringWithString:self.diaRecord] forKey:@"diaRecord"];
    }else if (0xFC == resultByte[2])
    {
        //测试结果
        NSLog(@"测试结果 %d %d %d",resultByte[3],resultByte[4],resultByte[5]);
        if (_pressureResult)
        {
            return;
            
        }
        if (!detectstarted) {
            return;
        }
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        [dicResult setValue:[NSNumber numberWithInteger:resultByte[3]]forKey:@"SSY"];
        [dicResult setValue:[NSNumber numberWithInteger:resultByte[4]]forKey:@"SZY"];
        [dicResult setValue:[NSNumber numberWithInteger:resultByte[5]]forKey:@"XL_OF_XY"];
        
        [self setPressureResult:dicResult];
        detectstarted = NO;
        [self setDevicesState:Measurement_Results];
    }else
    {
        if (!detectstarted)
        {
            return;
        }
        //异常
        if (self.XYMeasureErrorDelegate && [self.XYMeasureErrorDelegate respondsToSelector:@selector(measureBloodPressureError:)]) {
            [self.XYMeasureErrorDelegate measureBloodPressureError:resultByte[3]];
        }
    
        detectstarted = NO;
        [self setDevicesState:Measurement_Results];
    }
    
}

@end
