//
//  BodyDetectDevicesInfo.h
//  HMDoctor
//
//  Created by lkl on 2017/8/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceDetectRecord : NSObject

@property (nonatomic, copy) NSString *kpiCode;
@property (nonatomic, copy) NSString *kpiName;
@property (nonatomic, copy) NSString *deviceImg;

@end

@interface BodyDetectDevicesInfo : NSObject

+ (NSArray *)getDevicesInfo;

+ (NSArray *)getDevicesDetailInfo;
@end
