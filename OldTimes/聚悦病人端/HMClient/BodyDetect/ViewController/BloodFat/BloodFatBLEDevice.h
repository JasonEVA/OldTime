//
//  BloodFatBLEDevice.h
//  HMClient
//
//  Created by lkl on 16/5/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BluetoothDeviceControl.h"

@interface BloodFatBLEDevice : BluetoothDeviceControl

{
    NSMutableData *mData;
    
    NSString *tgValue;
    NSString *tcValue;
    NSString *hdcValue;
    NSString *ldcValue;
    
    NSString *tgSymbol;
    NSString *tcSymbol;
    NSString *hdcSymbol;
    NSString *ldlCSymbol;
    
    NSArray *tempArr;
}

@property (nonatomic, copy) NSDictionary* bloodFatResult;

@end
