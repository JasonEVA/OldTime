//
//  LastDetectRecord.h
//  HMClient
//
//  Created by yinqaun on 16/6/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DetectRecord.h"
#import "BloodPressureDetectRecord.h"
#import "HeartRateDetectRecord.h"
#import "BodyWeightDetectRecord.h"
#import "BloodSugarDetectRecord.h"
#import "BloodFatRecord.h"
#import "BloodOxygenationRecord.h"
#import "UrineVolumeRecord.h"
#import "BreathingDetctRecord.h"

@interface LastDetectRecord : DetectRecord
{
    
}
@property (nonatomic, retain) NSString* kpiTitle;
@property (nonatomic, retain) NSString* alertResultGrade;
@property (nonatomic, retain) NSString* unit;
@end



@interface LastBloodPressureDetectRecord : LastDetectRecord

@property (nonatomic, retain) BloodPressureValue* dataDets;
@property (nonatomic, assign) NSInteger SSY;        //收缩压
@property (nonatomic, assign) NSInteger SZY;        //舒张压
@property (nonatomic, assign) NSInteger XL_OF_XY;   //心率

@end

@interface LastHeartRateDetectRecord : LastDetectRecord

@property (nonatomic, retain) HeartRateDetectValue* dataDets;

@property (nonatomic, assign) NSInteger heartRate;

@end

@interface LastBodyWeightDetectRecord : LastDetectRecord

@property (nonatomic, retain) BodyWeightDetectValue* dataDets;
@property (nonatomic, assign) float bodyHeight;
@property (nonatomic, assign) float bodyWeight;
@property (nonatomic, assign) float bodyBMI;
@end

@interface LastBloodSugarDetectRecord : LastDetectRecord

@property (nonatomic, retain) BloodSugarDetectValue* dataDets;
@property (nonatomic, assign) float bloodSugar;
@property (nonatomic, retain) NSString* detectTimeName;

@end

@interface LastBloodFatDetectRecord : LastDetectRecord
@property (nonatomic, retain) BloodFatValue* dataDets;
@property (nonatomic, assign) float TC;
@property (nonatomic, assign) float TG;
@property (nonatomic, assign) float LDL_C;
@property (nonatomic, assign) float HDL_C;
@property (nonatomic, assign) float TC_DIVISION_HDL_C;
@end

@interface LastBloodOxygenationDetectRecord : LastDetectRecord

@property (nonatomic, retain) BloodOxygenationValue* dataDets;
@property (nonatomic, assign) NSInteger OXY_SUB;
@property (nonatomic, assign) NSInteger PULSE_RATE;
@property (nonatomic, assign) NSInteger PI_VAL;
@end

@interface LastUrineVolumeDetectRecord : LastDetectRecord

@property (nonatomic, retain) UrineVolumeValue* dataDets;
@property (nonatomic, assign) NSInteger urineVolume;
@property (nonatomic, retain) NSString* timeType;

@property (nonatomic, assign) NSInteger NL_SUB_DAY;
@property (nonatomic, assign) NSInteger NL_SUB_NIGHT;



@end

@interface LastBreathingDetectRecord : LastDetectRecord

@property (nonatomic, retain) BreathingDetctValue* dataDets;
@property (nonatomic, assign) NSInteger breathrate;

@end

