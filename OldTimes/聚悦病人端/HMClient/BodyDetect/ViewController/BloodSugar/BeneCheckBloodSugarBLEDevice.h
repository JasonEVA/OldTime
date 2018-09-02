//
//  BeneCheckBloodSugarBLEDevice.h
//  HMClient
//
//  Created by lkl on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BluetoothDeviceControl.h"

@interface BeneCheckBloodSugarBLEDevice : BluetoothDeviceControl

@property (nonatomic, copy) NSDictionary* bloodSugarResult;    //

@end
