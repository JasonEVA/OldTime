//
//  YuwellBloodPressureBLEDevice.m
//  BleTest
//
//  Created by lkl on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BluetoothDeviceControl.h"

@interface YuwellBloodPressureBLEDevice : BluetoothDeviceControl

@property (nonatomic,copy) NSString *systolicValue;
@property (nonatomic,copy) NSString *diastolicValue;
@property (nonatomic,copy) NSString *pulseValue;

@property(nonatomic,copy)NSString       *diaRecord;       //舒张压

@property (nonatomic, copy) NSDictionary* pressureResult;    //血压测试结果
@end
