//
//  RecordHealthInfo.h
//  HMClient
//
//  Created by lkl on 16/5/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordHealthInfo : NSObject

@end

@interface HealthPlanRecord : NSObject

@property (nonatomic,retain)NSString *code;
@property (nonatomic,retain)NSString *healthyName;
@property (nonatomic,retain)NSString *healthyContent;

@end

@interface DeviceDetectRecord : NSObject<NSCoding>

@property (nonatomic,retain)NSString *kpiCode;
@property (nonatomic,retain)NSString *kpiName;
@property (nonatomic,retain)NSString *alertContent;
@property (nonatomic,retain)NSString *isShow;
@property (nonatomic,retain)NSString *relationId;
@property (nonatomic,retain)NSString *sort;
@property (nonatomic,retain)NSString *userId;

@end