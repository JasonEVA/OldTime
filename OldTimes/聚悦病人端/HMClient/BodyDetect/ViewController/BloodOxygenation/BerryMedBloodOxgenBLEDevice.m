//
//  BerryMedBloodOxgenBLEDevice.m
//  HMClient
//
//  Created by lkl on 16/5/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BerryMedBloodOxgenBLEDevice.h"

@implementation BerryMedBloodOxgenBLEDevice


-(NSMutableArray *)dataArray
{
    if(!_dataArray)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(BMOximeterParams *)oximeterParams
{
    if (!_oximeterParams) {
        _oximeterParams = [[BMOximeterParams alloc]init];
    }
    return _oximeterParams;
}

- (void) controlSetup
{
    validDeviceName = [NSString stringWithFormat:@"BerryMed"];
    [super controlSetup];
}

#pragma mark - 设置代理
//  当外设发现服务的时候,会调用该方法
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services)
    {
        if([service.UUID isEqual:[CBUUID UUIDWithString:@"49535343-FE7D-4AE5-8FA9-9FAFD205E455"]])
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
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"49535343-1E4D-4BD9-BA61-23C647249616"]])
        {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            [peripheral readValueForCharacteristic:characteristic];
        }
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"49535343-8841-43F4-A8D4-ECBE34729BB3"]])
        {
            [peripheral readValueForCharacteristic:characteristic];
        }
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"00005343-0000-1000-8000-00805F9B34FB"]])
        {
            [peripheral readValueForCharacteristic:characteristic];
        }
    }
}

//当设备有数据返回时，系统调用这个方法
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"49535343-1E4D-4BD9-BA61-23C647249616"]])
    {
        [self addData:characteristic.value];
    }
}

-(void)addData:(NSData *)adata
{
    BOOL isPackageHeaderFound = NO;
    Byte package[5]           = {0};
    int  packageIndex         = 0;
    
    int  parserIndex = 0;
    int  i = 0;
    
    Byte *resultBytes = (Byte *)[adata bytes];
    for(int i= 0; i < adata.length; i++)
    {
        [self.dataArray addObject: [NSNumber numberWithInt:(int)(resultBytes[i]&0xff) ]];
    }
    
    if(self.dataArray.count < 10)
    {
        return;
        
    }
    
    while (i < self.dataArray.count)
    {
        //scan for package header
        if([self.dataArray[i] integerValue] & 0x80)
        {
            isPackageHeaderFound     = YES;
            package[packageIndex ++] = [self.dataArray[i] integerValue];
            i++;
            continue;
        }
        
        if(isPackageHeaderFound)
        {
            package[packageIndex ++] = [self.dataArray[i] integerValue];
            if(packageIndex == 5)
            {
                BMOximeterParams *params = [[BMOximeterParams alloc] init];
                
                params.piValue        = package[0] & 0x0f;
                params.waveAmplitude  = package[1];
                params.pulseRateValue = package[3] | ((package[2] & 0x40) << 1);
                params.SpO2Value      = package[4];
                
                if (params.SpO2Value != self.oximeterParams.SpO2Value || params.pulseRateValue != self.oximeterParams.pulseRateValue)
                {
                    if (params.SpO2Value == [BMOximeterParams SpO2InvalidValue] &  params.pulseRateValue == [BMOximeterParams pulseRateInvalidValue])
                    {
                        NSLog(@"无效数据");
                    }else
                    {
                        [self.bloodOxygenDelegate didRefreshOximeterParams:params];
                        
                    }
                }
                
                self.oximeterParams = params;
                
                packageIndex         = 0;
                isPackageHeaderFound = NO;
                parserIndex          = i;
                memset(package, 0, sizeof(package));
                
            }
        }
        
        i++;
        
    }
    [self.dataArray removeObjectsInRange:NSMakeRange(0, parserIndex+1)];
}


@end
