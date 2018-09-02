//
//  HealthKitManage.h
//  JYClientDemo
//
//  Created by yinquan on 2017/5/3.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HealthKitAuthorize)(BOOL success, NSError *error);

typedef void(^HealthKitStepCount)(double value, NSError *error);
typedef void(^HealthKitDistance)(double value, NSError *error);

@interface HealthKitManage : NSObject

+(id)shareInstance;

/*
 *   检查是否支持获取健康数据
 */
- (void)authorizeHealthKit:(HealthKitAuthorize)compltion;


//获取指定日期步数
- (void)getStepCountWithDatd:(NSDate*) date completion:(HealthKitStepCount)completion ;


//获取指定日期公里数
- (void)getDistanceWithDate:(NSDate*) date completion:(HealthKitStepCount)completion;
@end
