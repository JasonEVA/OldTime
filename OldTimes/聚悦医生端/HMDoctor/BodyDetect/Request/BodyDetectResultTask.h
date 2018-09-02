//
//  BodyDetectResultTask.h
//  HMClient
//
//  Created by yinqaun on 16/5/9.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SingleHttpRequestTask.h"

@interface BodyDetectResultTask : SingleHttpRequestTask

@end

@interface BloodPressureDetectResultTask : BodyDetectResultTask

@end

@interface ECGDetectResultTask : BodyDetectResultTask

@end

@interface HeartRateDetectResultTask : BodyDetectResultTask

@end

@interface BodyWeightDetectResultTask : BodyDetectResultTask

@end

@interface BloodSugarDetectResultTask : BodyDetectResultTask

@end

@interface BloodFatDetectResultTask : BodyDetectResultTask

@end

@interface BloodOxygenationDetectResultTask : BodyDetectResultTask

@end

@interface BreathingDetectResultTask : BodyDetectResultTask

@end

@interface BodyTemperatureDetectResultTask : BodyDetectResultTask

@end
