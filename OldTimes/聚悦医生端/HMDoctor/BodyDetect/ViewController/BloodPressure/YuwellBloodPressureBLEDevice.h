//
//  YuwellBloodPressureBLEDevice.m
//  BleTest
//
//  Created by lkl on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "JYBluetoothManager.h"

@interface BloodPressureRetModel : NSObject

@property (nonatomic, assign) NSInteger systolic;   //收缩压
@property (nonatomic, assign) NSInteger diastolic;   //舒张压
@property (nonatomic, assign) NSInteger heartRate;   //心率

@end

@protocol YuwellBloodPressureBluUtilDelegate <JYBluetoothManagerDelegate>

@required
- (void) detectingPressure:(NSInteger) pressure;

- (void) detectedsystolic:(NSInteger) systolic diastolic:(NSInteger) diastolic heartRate:(NSInteger) heartRate;

@end

@interface YuwellBloodPressureBLEDevice : JYBluetoothManager

@end
