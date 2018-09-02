//
//  MaiboboBloodPressureBLEManager.h
//  HMClient
//
//  Created by lkl on 2017/10/17.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "JYBluetoothManager.h"

typedef NS_ENUM(NSInteger , BPRespondType) {
    BPRespondType_Connect,   //连接应答
    BPRespondType_Start,     //开始应答
    BPRespondType_Stop,      //停止应答
    BPRespondType_PowerOff,  //关机应答
};

@protocol MaiboboBPBLEDelegate <JYBluetoothManagerDelegate>

@required

- (void)detectBPRespondType:(BPRespondType)type;

- (void)detectingBPValue:(NSInteger)value;

- (void)detectedsystolic:(NSInteger)systolic diastolic:(NSInteger)diastolic heartRate:(NSInteger)heartRate;

- (void)detectError:(NSString *)errorMsg;
@end

@interface MaiboboBloodPressureBLEManager : JYBluetoothManager

@end
