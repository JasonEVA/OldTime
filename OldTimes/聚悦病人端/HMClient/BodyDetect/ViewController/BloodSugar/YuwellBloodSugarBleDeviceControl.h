//
//  YuwellBloodSugarBleDeviceControl.h
//  HMClient
//
//  Created by yinquan on 2017/6/5.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BluetoothDeviceControl.h"

@interface YuwellBloodSugarBleDeviceControl : BluetoothDeviceControl

@property (nonatomic, copy) NSDictionary* bloodSugarResult;

@end
