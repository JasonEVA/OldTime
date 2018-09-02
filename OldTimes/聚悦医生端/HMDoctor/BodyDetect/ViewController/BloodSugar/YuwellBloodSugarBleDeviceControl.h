//
//  YuwellBloodSugarBleDeviceControl.h
//  HMClient
//
//  Created by yinquan on 2017/6/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "JYBluetoothManager.h"

@protocol YuwellBloodBloodSugarBLEDelegate <JYBluetoothManagerDelegate>

- (void)detectBloodSugarValue:(float)value;

@end

@interface YuwellBloodSugarBleDeviceControl : JYBluetoothManager

@property (nonatomic, copy) NSDictionary* bloodSugarResult;

@end
