//
//  BerryMedBloodOxgenBLEDevice.h
//  HMClient
//
//  Created by lkl on 16/5/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "JYBluetoothManager.h"
#import "BMOximeterParams.h"

@protocol BloodOxygenBLEResultDelegate
//血氧
- (void)didRefreshOximeterParams:(BMOximeterParams*)params;

@end

@interface BerryMedBloodOxgenBLEDevice : JYBluetoothManager

@property(nonatomic,copy) NSMutableArray   *dataArray;
@property(nonatomic,strong) BMOximeterParams *oximeterParams;

@property (nonatomic, weak) id<BloodOxygenBLEResultDelegate> bloodOxygenDelegate;

@end
