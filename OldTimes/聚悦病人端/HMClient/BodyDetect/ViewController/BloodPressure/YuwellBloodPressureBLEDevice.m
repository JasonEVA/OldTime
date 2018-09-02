//
//  YuwellBloodPressureBLEDevice.m
//  BleTest
//
//  Created by lkl on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "YuwellBloodPressureBLEDevice.h"

@implementation YuwellBloodPressureBLEDevice

- (void) controlSetup
{
    validDeviceName = [NSString stringWithFormat:@"Yuwell BloodPressure"];
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
        if ([name isEqualToString:@"Yuwell BloodPressure"] || [name isEqualToString:@"Yuwell BP-YE680A"])
        {
            return YES;
        }
        
    }
    return NO;
}

#pragma mark - 设置代理
//  当外设发现服务的时候,会调用该方法
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services)
    {
        if([service.UUID isEqual:[CBUUID UUIDWithString:@"1810"]])
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
    if (!error)
    {
        for (CBCharacteristic *characteristic in service.characteristics)
        {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A35"]])
            {
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A36"]])
            {
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A08"]])
            {
                self.characteristic = characteristic;
            }
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
    uint8_t *array = (uint8_t*) adata.bytes;
    
    //测量结果
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A35"]] || [characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A36"]])
    {
        UInt8 flags = [self readUInt8Value:&array];
        BOOL timestampPresent = (flags & 0x02) > 0;
        BOOL pulseRatePresent = (flags & 0x04) > 0;
        
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A35"]])
        {
            self.systolicValue = [NSString stringWithFormat:@"%.f", [self readSFloatValue:&array]];
            self.diastolicValue = [NSString stringWithFormat:@"%.f", [self readSFloatValue:&array]];
            float meanApValue = [self readSFloatValue:&array];
            
            NSLog(@"====%@,%@,%f",_systolicValue,_diastolicValue,meanApValue);
        }else   //测试中
        {
            float systolicValue = [self readSFloatValue:&array];
            array += 4;
            self.diaRecord = [NSString stringWithFormat:@"%.f", systolicValue];
            
            [self setValue:self.diaRecord forKey:@"diaRecord"];
        }
        
        // Read timestamp
        if (timestampPresent)
        {
            NSDate* date = [self readDateTime:&array];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"dd.MM.yyyy, hh:mm"];
            NSString* dateFormattedString = [dateFormat stringFromDate:date];
            NSLog(@"-%@",dateFormattedString);
        }
        
        // Read pulse
        if (pulseRatePresent)
        {
            float pulse = [self readSFloatValue:&array];
            self.pulseValue = [NSString stringWithFormat:@"%.1f", pulse];
        }
        
        if(_systolicValue && _diastolicValue && _pulseValue.floatValue <= 300.0)
        {
            NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
            [dicResult setValue:[NSString stringWithFormat:@"%d",self.systolicValue.intValue] forKey:@"SSY"];
            [dicResult setValue:[NSString stringWithFormat:@"%d",self.diastolicValue.intValue] forKey:@"SZY"];
            [dicResult setValue:[NSString stringWithFormat:@"%d",self.pulseValue.intValue] forKey:@"XL_OF_XY"];
            
            [self setPressureResult:dicResult];
            [self setDevicesState:4];
        }

    }
}

-(NSDate *)readDateTime:(uint8_t **)p_encoded_data
{
    uint16_t year = [self readUInt16Value:p_encoded_data];
    uint8_t month = [self readUInt8Value:p_encoded_data];
    uint8_t day = [self readUInt8Value:p_encoded_data];
    uint8_t hour = [self readUInt8Value:p_encoded_data];
    uint8_t min = [self readUInt8Value:p_encoded_data];
    uint8_t sec = [self readUInt8Value:p_encoded_data];
    
    NSString * dateString = [NSString stringWithFormat:@"%d %d %d %d %d %d", year, month, day, hour, min, sec];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat: @"yyyy MM dd HH mm ss"];
    return  [dateFormat dateFromString:dateString];
}

- (UInt16)readUInt16Value:(uint8_t **)p_encoded_data
{
    UInt16 value = (UInt16) CFSwapInt16LittleToHost(*(uint16_t*)*p_encoded_data);
    *p_encoded_data += 2;
    return value;
}

- (UInt8)readUInt8Value:(uint8_t **)p_encoded_data
{
    return *(*p_encoded_data)++;
}

- (Float32)readSFloatValue:(uint8_t **)p_encoded_data
{
    SInt16 tempData = (SInt16) CFSwapInt16LittleToHost(*(uint16_t*)*p_encoded_data);
    SInt8 exponent = (SInt8)(tempData >> 12);
    SInt16 mantissa = (SInt16)(tempData & 0x0FFF);
    *p_encoded_data += 2;
    return (Float32)(mantissa * pow(10, exponent));
}

@end
