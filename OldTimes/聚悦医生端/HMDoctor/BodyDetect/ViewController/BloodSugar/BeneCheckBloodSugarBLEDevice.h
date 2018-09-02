//
//  BeneCheckBloodSugarBLEDevice.h
//  HMClient
//
//  Created by lkl on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "JYBluetoothManager.h"

@protocol BeneCheckBloodSugarBLEDelegate <JYBluetoothManagerDelegate>

- (void)detectBloodSugarValue:(float)value;
- (void)detectBloodSugarError;

@end

@interface BeneCheckBloodSugarBLEDevice : JYBluetoothManager

@end
