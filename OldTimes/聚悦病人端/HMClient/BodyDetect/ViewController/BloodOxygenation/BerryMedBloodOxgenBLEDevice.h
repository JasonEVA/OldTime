//
//  BerryMedBloodOxgenBLEDevice.h
//  HMClient
//
//  Created by lkl on 16/5/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "BluetoothDeviceControl.h"
#import "BMOximeterParams.h"

@protocol BloodOxygenBLEResultDelegate
//血氧
- (void)didRefreshOximeterParams:(BMOximeterParams*)params;

@end

@interface BerryMedBloodOxgenBLEDevice : BluetoothDeviceControl

@property(nonatomic,copy) NSMutableArray   *dataArray;
@property(nonatomic,strong) BMOximeterParams *oximeterParams;

@property (nonatomic, copy) NSDictionary *bloodOxygenResult;

@property (nonatomic, weak) id<BloodOxygenBLEResultDelegate> bloodOxygenDelegate;

@end
