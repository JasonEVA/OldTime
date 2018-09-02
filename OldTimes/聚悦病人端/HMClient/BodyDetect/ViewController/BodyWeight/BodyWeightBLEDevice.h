//
//  BodyWeightBLEDevice.h
//  HMClient
//
//  Created by lkl on 2017/4/6.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BluetoothDeviceControl.h"

@interface BodyWeightBLEDevice : BluetoothDeviceControl

@property (nonatomic, strong) NSDictionary *bodyWeightResult;
@property (nonatomic,assign) NSInteger serialNum;

@end
