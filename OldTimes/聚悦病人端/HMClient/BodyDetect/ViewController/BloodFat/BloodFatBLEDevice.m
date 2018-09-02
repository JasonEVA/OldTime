//
//  BloodFatBLEDevice.m
//  HMClient
//
//  Created by lkl on 16/5/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BloodFatBLEDevice.h"

@implementation BloodFatBLEDevice

- (void) controlSetup
{
    validDeviceName = [NSString stringWithFormat:@"CardioChek-Meter"];
    [super controlSetup];
}

#pragma mark - 设置代理
//  当外设发现服务的时候,会调用该方法
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services)
    {
        if([service.UUID isEqual:[CBUUID UUIDWithString:@"F808"]])
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
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"fa52"]])
        {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            [peripheral readValueForCharacteristic:characteristic];
        }
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"fa51"]])
        {
            self.characteristic = characteristic;
        }
    }
}

//当设备有数据返回时，系统调用这个方法
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"fa52"]])
    {
        NSData *adata = characteristic.value;
        if (!adata)
        {
            return;
        }
        
        if (!mData)
        {
            mData = [[NSMutableData alloc] init];
        }
        [mData appendData:adata];
        
        //Byte *resultByte = (Byte *)[mData bytes];
        if (mData.length == 264)
        {
            NSString *str = [[NSString alloc] initWithData:mData encoding:NSASCIIStringEncoding];
            
            NSString *valueString = [[str stringByReplacingOccurrencesOfString:@" " withString:@""]stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
            
            NSArray *array = [valueString componentsSeparatedByString:@":"];
            
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (NSString *str in array)
            {
                NSArray *tempArray = [str componentsSeparatedByString:@"mmol/L"];
                
                if (tempArray.count > 1)
                {
                    [arr addObject:tempArray[0]];
                    
                }
            }
            NSLog(@"arr:%@",arr);
            
            //NSMutableArray *valueArr = [[NSMutableArray alloc] init];
            //NSMutableArray *symbolArr = [[NSMutableArray alloc] init];
            
            NSMutableDictionary *dicParm = [NSMutableDictionary dictionary];
            
            for (int i = 0; i < arr.count; i++)
            {
                NSString *str = [arr objectAtIndex:i];
                NSString *firstStr = [str substringWithRange:NSMakeRange(0, 1)];
                
                if (![firstStr isPureInt])
                {
                    if (!tempArr) {
                        tempArr = [[NSArray alloc] init];
                    }
                    if ([firstStr isEqualToString:@"<"])
                    {
                        tempArr = [str componentsSeparatedByString:@"<"];
                    }else
                    {
                        tempArr = [str componentsSeparatedByString:@">"];
                    }
                    switch (i)
                    {
                        case 0:
                        {
                            tcSymbol = [tempArr objectAtIndex:0];
                            tcValue = [tempArr objectAtIndex:1];
                        }
                            break;
                            
                        case 1:
                        {
                            hdcSymbol = [tempArr objectAtIndex:0];
                            hdcValue = [tempArr objectAtIndex:1];
                        }
                            break;
                            
                        case 2:
                        {
                            tgSymbol = [tempArr objectAtIndex:0];
                            tgValue = [tempArr objectAtIndex:1];
                        }
                            break;
                            
                        case 3:
                        {
                            ldlCSymbol = [tempArr objectAtIndex:0];
                            ldcValue = [tempArr objectAtIndex:1];
                        }
                            break;
                            
                        default:
                            break;
                    }
                    
                    //NSLog(@"%@ --%@ %@",tcValue,hdcValue,tgValue);
                    [dicParm setValue:tcValue forKey:@"TC"];
                    //[dicParm setValue:tcSymbol forKey:@"tcSymbol"];
                    
                    [dicParm setValue:hdcValue forKey:@"HDL_C"];
                    //[dicParm setValue:hdcSymbol forKey:@"hdcSymbol"];
                    
                    [dicParm setValue:tgValue forKey:@"TG"];
                    //[dicParm setValue:tgSymbol forKey:@"tgSymbol"];
                    
                    [dicParm setValue:ldcValue forKey:@"LDL_C"];
                    //[dicParm setValue:ldlCSymbol forKey:@"ldlCSymbol"];
                }else    //第一位是数字，直接保存
                {
                    switch (i)
                    {
                        case 0:
                            [dicParm setValue:str forKey:@"TC"];
                            break;
                            
                        case 1:
                            [dicParm setValue:str forKey:@"HDL_C"];
                            break;
                            
                        case 2:
                            [dicParm setValue:str forKey:@"TG"];
                            break;
                            
                        case 3:
                            [dicParm setValue:str forKey:@"LDL_C"];
                            break;
                            
                        default:
                            break;
                    }
                }
            }
            [self setBloodFatResult:dicParm];
            
        }
    }
}


@end
