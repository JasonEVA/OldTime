//
//  BodyWeightBLEDevice.m
//  HMClient
//
//  Created by lkl on 2017/4/6.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BodyWeightBLEDevice.h"
#import "SysConvertUtil.h"

@implementation BodyWeightBLEDevice

- (void) controlSetup
{
    validDeviceName = [NSString stringWithFormat:@"000FatScale01"];
    [super controlSetup];
}

#pragma mark - 设置代理
//  当外设发现服务的时候,会调用该方法
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"didDiscoverServices : %@", [error localizedDescription]);
        return;
    }
    for (CBService *service in peripheral.services) {
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
    if (error)
    {
        NSLog(@"didDiscoverCharacteristicsForService error : %@", [error localizedDescription]);
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF1"]])
        {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            self.characteristic = characteristic;
        }
        
    }
}

//当设备有数据返回时，系统调用这个方法
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF1"]])
    {
        NSData *valueData = characteristic.value;
        
        if (!valueData)
        {
            return;
        }
        Byte *resultByte = (Byte *)[valueData bytes];
        for (int i = 0; i < [valueData length]; i++) {
            
            if (resultByte[1] == 0xd8) {
                //量测中的重量
            }
            
            //电压数据
            if (resultByte[11] == 0x80){
                //低电压
            }
            
            //上传当前测试结果
            if (resultByte[1] == 0xdd) {
                
                //数据流水号
                if (resultByte[10] == _serialNum) {
                    return;
                }
                
                _serialNum = resultByte[10];
                
                NSString *str = [SysConvertUtil decimalTOBinary:resultByte[2] backLength:8];
                NSString *unitBitStr = [str substringToIndex:2];
                
                NSString *heightBitStr = [str substringFromIndex:2];
                int heightWei = [SysConvertUtil toDecimalSystemWithBinarySystem:heightBitStr];
                float tempResult = (heightWei << 8) + resultByte[3];
                
                NSString *weightUnitStr;
                float weightValue = tempResult / 10;        //Kg
                if ([unitBitStr isEqualToString:@"00"]) {
                    weightUnitStr = @"Kg";
                }
                else if ([unitBitStr isEqualToString:@"10"]){
                    //LB:  1LB=0.454Kg
                    weightUnitStr = @"LB";
                    weightValue = 0.454 * weightValue;
                }
                else{
                    //ST:  1 英石=6.35 千克
                    weightUnitStr = @"ST";
                    weightValue = 6.35 * weightValue;
                }
                
                NSMutableDictionary *dicParm = [NSMutableDictionary dictionary];
                [dicParm setValue:[NSString stringWithFormat:@"%.1f",weightValue] forKey:@"TZ_SUB"];
                [self setBodyWeightResult:dicParm];
            }
        }
    }
}

@end
