//
//  BodyDetectRecordsTask.h
//  HMClient
//
//  Created by yinqaun on 16/5/9.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SingleHttpRequestTask.h"

@interface BodyDetectRecordsTask : SingleHttpRequestTask

@end


//血压监测数据记录
@interface BloodPressureRecordsTask : BodyDetectRecordsTask

@end

//心电检测数据记录
@interface ECGRecordsTask : BodyDetectRecordsTask

@end

//心率检测数据记录
@interface HeartRateRecordsTask : BodyDetectRecordsTask

@end

//体重监测数据记录
@interface BodyWeightRecordsTask : BodyDetectRecordsTask

@end

//血糖监测数据记录
@interface BloodSugarRecordsTask : BodyDetectRecordsTask

@end

//血脂监测数据记录
@interface BloodFatRecordsTask : BodyDetectRecordsTask

@end

//血氧监测数据记录
@interface BloodOxygenationRecordsTask : BodyDetectRecordsTask

@end

//尿量监测数据记录
@interface UrineVolumeRecordsTask : BodyDetectRecordsTask

@end

//呼吸监测数值记录
@interface BreathingRecordsTask : BodyDetectRecordsTask

@end

//体温监测数值记录
@interface BodyTemperatureRecordsTask : BodyDetectRecordsTask

@end

//峰流速值数值记录
@interface PEFRecordsTask : BodyDetectRecordsTask

@end
