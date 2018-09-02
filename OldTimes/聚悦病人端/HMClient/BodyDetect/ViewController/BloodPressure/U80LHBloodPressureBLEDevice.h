//
//  U80LHBloodPressureBLEDevice.h
//  HMClient
//
//  Created by lkl on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BluetoothDeviceControl.h"

@protocol BloodPressureBluetoothControlResultDelegate <NSObject>

- (void) measureBloodPressureError:(float)value;

@end

@interface U80LHBloodPressureBLEDevice : BluetoothDeviceControl


@property(nonatomic,copy)NSString       *sysRecord;       //收缩压
@property(nonatomic,copy)NSString       *diaRecord;       //舒张压
@property(nonatomic,copy)NSString       *pulRecord;       //心率

@property (nonatomic, copy) NSDictionary* pressureResult;    //血压测试结果

@property (nonatomic, weak) id<BloodPressureBluetoothControlResultDelegate> XYMeasureErrorDelegate;

@end
