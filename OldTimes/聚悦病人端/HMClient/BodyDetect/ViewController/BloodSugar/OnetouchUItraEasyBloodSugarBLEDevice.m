//
//  OnetouchUItraEasyBloodSugarBLEDevice.m
//  HMClient
//
//  Created by lkl on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "OnetouchUItraEasyBloodSugarBLEDevice.h"
#import "SysConvertUtil.h"

@implementation OnetouchUItraEasyBloodSugarBLEDevice

- (void) controlSetup
{
    validDeviceName = [NSString stringWithFormat:@"UltraEasy-"];
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
        if ([name hasPrefix:@"UltraEasy-"])
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
    if (!error)
    {
        for (CBCharacteristic *characteristic in service.characteristics)
        {
            NSLog(@"特征的UUID：%@",characteristic);
            
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A18"]])
            {
                [peripheral readValueForCharacteristic:characteristic];
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A52"]])
            {
                self.characteristic = characteristic;
                
                //给蓝牙发指令（写数据）
                [peripheral writeValue:[self bytesStringToData:@"0101"] forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
            }
        }
    }else{
        printf("Characteristic discovery fail!");
    }
}

//当设备有数据返回时，系统调用这个方法
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A18"]])
    {
        NSData *valueData = characteristic.value;
        if (!valueData || error)
        {
            return;
        }
        
        Byte *resultByte = (Byte *)[valueData bytes];
        
        if (valueData.length == 17)
        {
            NSString *yearStr = [SysConvertUtil binaryStringWithInt:(resultByte[3] + (resultByte[4]<<8))];
            int year = [SysConvertUtil toDecimalSystemWithBinarySystem:yearStr];
            
            int month = resultByte[5];
            int day = resultByte[6];
            int hour = resultByte[7];
            int min = resultByte[8];
            int second = resultByte[9];
            
            NSString *dateString = [NSString stringWithFormat:@"%d-%d-%-d %d:%d:%d",year,month,day,hour,min,second];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [formatter dateFromString:dateString];
            
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *valueString = [formatter stringFromDate:date];
            
            
            NSString *binaryStr = [SysConvertUtil binaryStringWithInt:(resultByte[12] + (resultByte[13]<<8))];
            
            NSString *perFourStr = [binaryStr substringWithRange:NSMakeRange(0, 4)];
            int perFourValue = [SysConvertUtil toDecimalSystemWithBinarySystem:perFourStr];
            
            if (perFourValue > 8)
            {
                perFourValue = perFourValue - 16;
            }else{
                perFourValue = -perFourValue;
            }
            
            NSString *str16th = [binaryStr substringWithRange:NSMakeRange(4, 12)];
            int int16th = [SysConvertUtil toDecimalSystemWithBinarySystem:str16th];
            
            float valuef = int16th * (pow(10, perFourValue) * 100000)/18;
            
            NSLog(@"血糖值：%f",valuef);
            flag ++;
            if (flag == 1)
            {
                NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
                
                [dicResult setValue:valueString forKey:@"uniqueTestGid"];
                
                [dicResult setValue:[NSNumber numberWithFloat:valuef] forKey:@"XT_SUB"];
                
                [self setBloodSugarResult:dicResult];
                //[self setDevicesState:4];
            }
        }
    }
}

-(NSData*)bytesStringToData:(NSString*)bytesString
{
    if (!bytesString || !bytesString.length) return NULL;
    // Get the c string
    const char *scanner=[bytesString cStringUsingEncoding:NSUTF8StringEncoding];
    char twoChars[3]={0,0,0};
    long bytesBlockSize = bytesString.length/2;
    long counter = bytesBlockSize;
    Byte *bytesBlock = malloc(bytesBlockSize);
    if (!bytesBlock) return NULL;
    Byte *writer = bytesBlock;
    while (counter--) {
        twoChars[0]=*scanner++;
        twoChars[1]=*scanner++;
        *writer++ = strtol(twoChars, NULL, 16);
    }
    return[NSData dataWithBytesNoCopy:bytesBlock length:bytesBlockSize freeWhenDone:YES];
}

- (void) showAlertMessage:(NSString*) msg
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}


@end
