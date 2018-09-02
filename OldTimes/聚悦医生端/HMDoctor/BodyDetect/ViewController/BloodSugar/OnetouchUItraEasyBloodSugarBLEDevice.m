//
//  OnetouchUItraEasyBloodSugarBLEDevice.m
//  HMClient
//
//  Created by lkl on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "OnetouchUItraEasyBloodSugarBLEDevice.h"
#import "BodyDetectSysConvertUtil.h"

@implementation OnetouchUItraEasyBloodSugarBLEDevice

//设备名称
- (BOOL)checkDeviceName:(NSString*) deviceName{
    if (!deviceName || deviceName.length == 0){
        return NO;
    }
    
    if ([deviceName hasPrefix:@"UltraEasy-"]){
        return YES;
    }
    return NO;
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

//发送命令
- (NSData *)sendCommand{
    return [self bytesStringToData:@"0101"];
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

- (void)parseReceiveData:(NSData *)valueData{
    
    Byte *resultByte = (Byte *)[valueData bytes];
    
    if (valueData.length == 17)
    {
        NSString *yearStr = [BodyDetectSysConvertUtil binaryStringWithInt:(resultByte[3] + (resultByte[4]<<8))];
        int year = [BodyDetectSysConvertUtil toDecimalSystemWithBinarySystem:yearStr];
        
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
        
        
        NSString *binaryStr = [BodyDetectSysConvertUtil binaryStringWithInt:(resultByte[12] + (resultByte[13]<<8))];
        
        NSString *perFourStr = [binaryStr substringWithRange:NSMakeRange(0, 4)];
        int perFourValue = [BodyDetectSysConvertUtil toDecimalSystemWithBinarySystem:perFourStr];
        
        if (perFourValue > 8)
        {
            perFourValue = perFourValue - 16;
        }else{
            perFourValue = -perFourValue;
        }
        
        NSString *str16th = [binaryStr substringWithRange:NSMakeRange(4, 12)];
        int int16th = [BodyDetectSysConvertUtil toDecimalSystemWithBinarySystem:str16th];
        
        float valuef = int16th * (pow(10, perFourValue) * 100000)/18;
        
        NSLog(@"血糖值：%f",valuef);
        flag ++;
        if (flag == 1)
        {
            NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
            
            [dicResult setValue:valueString forKey:@"uniqueTestGid"];
            
            [dicResult setValue:[NSNumber numberWithFloat:valuef] forKey:@"XT_SUB"];
            
            id <OnetouchUItraEasyBloodSugarBLEDelegate> OnetouchUItraEasyBLEDelegate = (id<OnetouchUItraEasyBloodSugarBLEDelegate>)self.bluetoothDelegate;
            if (OnetouchUItraEasyBLEDelegate && [OnetouchUItraEasyBLEDelegate respondsToSelector:@selector(detectBloodSugarValue:)]) {
                [OnetouchUItraEasyBLEDelegate detectBloodSugarValue:dicResult];
            }
        }
    }
}

@end
