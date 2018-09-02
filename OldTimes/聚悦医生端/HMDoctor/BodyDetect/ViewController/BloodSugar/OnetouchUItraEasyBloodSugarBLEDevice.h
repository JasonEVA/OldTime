//
//  OnetouchUItraEasyBloodSugarBLEDevice.h
//  HMClient
//
//  Created by lkl on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "JYBluetoothManager.h"


@protocol OnetouchUItraEasyBloodSugarBLEDelegate <JYBluetoothManagerDelegate>

- (void)detectBloodSugarValue:(NSMutableDictionary *)valueDic;

@end

@interface OnetouchUItraEasyBloodSugarBLEDevice : JYBluetoothManager
{
    int flag;
}

@end
