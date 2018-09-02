//
//  MaiboboBloodPressureBLEManager.m
//  HMClient
//
//  Created by lkl on 2017/10/17.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "MaiboboBloodPressureBLEManager.h"

@implementation MaiboboBloodPressureBLEManager

//设备名称
- (BOOL)checkDeviceName:(NSString*) deviceName{
    if (!deviceName || deviceName.length == 0){
        return NO;
    }
    
//    if ([deviceName isEqualToString:@"BP06D21702140271"]) {
//        return YES;
//    }
    if ([deviceName hasPrefix:@"BP"] || [deviceName hasPrefix:@"RBP"]) {
        return YES;
    }
    return NO;
}

//服务
- (BOOL)checkDeviceService:(CBService *)service{
    if (!service) {
        return NO;
    }
    return [service.UUID isEqual:[CBUUID UUIDWithString:@"FFF0"]];
}

//读特征
- (BOOL)checkNotifyingCharacteristics:(CBCharacteristic *)characteristic{
    if (!characteristic) {
        return NO;
    }
    return ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF1"]]);
}

//写特征
- (BOOL)checkWriteCharacteristic:(CBCharacteristic *)characteristic{
    if (!characteristic) {
        return NO;
    }
    return [characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF2"]];
}

//发送命令
- (NSData *)sendCommand{
    Byte byte[] = {0xcc,0x80,0x02,0x03,0x01,0x01,0x00,0x01};
    NSData *data = [[NSData alloc] initWithBytes:byte length:8];
    return data;
}

- (void)parseReceiveData:(NSData *)valueData
{
    NSLog(@"%@",valueData);
    
    Byte *resultByte = (Byte *)[valueData bytes];
    
    id<MaiboboBPBLEDelegate> BleDelegate = (id<MaiboboBPBLEDelegate>) self.bluetoothDelegate;
    
    //应答 0、1:前导码 2:版本 3:数据长度 4:标识编号 5:子码编号 ……
    if (resultByte[0] == 0xaa && resultByte[1] == 0x80) {
        
        //aa800203 01010001
        if (resultByte[5] == 0x01) {  //连接血压计应答
            NSLog(@"连接血压计应答");
            [self detectBPRespondType:BPRespondType_Connect];
        }
        
        //aa80; 02030102 0002 分两个
        if (resultByte[5] == 0x02) {  //启动测量应答
            NSLog(@"启动测量应答");
            [self detectBPRespondType:BPRespondType_Start];
        }
        
        if (resultByte[5] == 0x03) {  //停止测量应答
            NSLog(@"停止测量应答");
            [self detectBPRespondType:BPRespondType_Stop];
        }
        
        if (resultByte[5] == 0x04) {  //关机应答
            NSLog(@"关机应答");
            [self detectBPRespondType:BPRespondType_PowerOff];
        }
        
        //aa800208 01050000 00004200 4c
        if (resultByte[5] == 0x05 && resultByte[3] == 0x08 && valueData.length == 13) {  //测量中
            NSInteger sysValue = (resultByte[7] << 8) + resultByte[10]^resultByte[11];
            NSLog(@"---%ld",sysValue);
            
            if (BleDelegate && [BleDelegate respondsToSelector:@selector(detectingBPValue:)])
            {
                [BleDelegate detectingBPValue:sysValue];
            }
        }
        
        //aa80020f 01060210 0a100b2c 07007a00 47004758
        if (resultByte[5] == 0x06 && resultByte[3] == 0x0f && valueData.length == 20) {   //测量结果
            NSInteger sysValue = (resultByte[13] << 8) + resultByte[14];
            NSInteger diaValue = (resultByte[15] << 8) + resultByte[16];
            NSInteger pulValue = (resultByte[17] << 8) + resultByte[18];
            NSLog(@"%ld %ld %ld",sysValue,diaValue,pulValue);
            
            if (BleDelegate && [BleDelegate respondsToSelector:@selector(detectedsystolic:diastolic:heartRate:)])
            {
                [BleDelegate detectedsystolic:sysValue diastolic:diaValue heartRate:pulValue];
            }
        }
        
        if (resultByte[5] == 0x07) {   // 错误信息
            if (resultByte[6] == 0x07) {
                NSLog(@"电池电量低");
                if (BleDelegate && [BleDelegate respondsToSelector:@selector(detectError:)]){
                    [BleDelegate detectError:@"电池电量低"];
                }
            }
            else{
                NSLog(@"测量错误");
                if (BleDelegate && [BleDelegate respondsToSelector:@selector(detectError:)]){
                    [BleDelegate detectError:@"测量错误,请重新测量"];
                }
            }
        }
    }
}

- (void)detectBPRespondType:(BPRespondType)type{
    
    id<MaiboboBPBLEDelegate> BleDelegate = (id<MaiboboBPBLEDelegate>) self.bluetoothDelegate;
    
    if (BleDelegate && [BleDelegate respondsToSelector:@selector(detectBPRespondType:)]){
        [BleDelegate detectBPRespondType:type];
    }
}

@end
