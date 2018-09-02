//
//  HellofitECGBLEDevice.h
//  HMClient
//
//  Created by lkl on 16/4/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "JYBluetoothManager.h"

@protocol ECGBluetoothControlResultDelegate <NSObject>
//心电
//- (void) measureECGSuccessWithPointsArray:(NSArray *)points;
- (void)measureECGSuccessWithDecodeData:(NSData *)valueData;
//- (void) measureECGStop;

@end

@interface HellofitECGBLEDevice : JYBluetoothManager

@property (nonatomic,strong) NSMutableArray *measureECGValueArray;

@property (nonatomic, weak) id<ECGBluetoothControlResultDelegate> ECGResultdelegate;

@end
