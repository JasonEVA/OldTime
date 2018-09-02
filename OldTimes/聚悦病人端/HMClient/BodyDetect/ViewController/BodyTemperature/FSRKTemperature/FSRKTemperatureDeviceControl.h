//
//  FSRKTemperatureDeviceControl.h
//  BlueToothDemo
//
//  Created by yinquan on 17/4/5.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "BluetoothDeviceControl.h"
#import "BodyTemperatureResultDelegate.h"


@interface FSRKTemperatureDeviceControl : BluetoothDeviceControl



@property (nonatomic, weak) id<BodyTemperatureResultDelegate> resultdelegate;

@end
