//
//  OnetouchUItraEasyBloodSugarBLEDevice.h
//  HMClient
//
//  Created by lkl on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BluetoothDeviceControl.h"

@interface OnetouchUItraEasyBloodSugarBLEDevice : BluetoothDeviceControl
{
    int flag;
}
@property (nonatomic, copy) NSDictionary* bloodSugarResult;

@end
