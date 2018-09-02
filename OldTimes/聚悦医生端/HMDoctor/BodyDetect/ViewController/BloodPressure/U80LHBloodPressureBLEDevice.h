//
//  U80LHBloodPressureBLEDevice.h
//  HMClient
//
//  Created by lkl on 16/4/27.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "JYBluetoothManager.h"

@protocol U80LHBloodPressureDelegate <NSObject>

- (void)measureBloodPressureError:(float)value;

- (void)detectingPressure:(NSInteger) pressure;
- (void)detectedWithDictionary:(NSDictionary *)dic;

@end

@interface U80LHBloodPressureBLEDevice : JYBluetoothManager


@property(nonatomic,copy)NSString       *sysRecord;       //收缩压
@property(nonatomic,copy)NSString       *diaRecord;       //舒张压
@property(nonatomic,copy)NSString       *pulRecord;       //心率

@property (nonatomic, copy) NSDictionary* pressureResult;    //血压测试结果

//@property (nonatomic, weak) id<U80LHBloodPressureDelegate> XYMeasureErrorDelegate;

@end
