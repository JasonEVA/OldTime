//
//  DetectDataRecordContentView.h
//  HMClient
//
//  Created by yinqaun on 16/5/12.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DetectRecord.h"

@interface DetectRecord (DataRecord)

- (NSString*) recordname;
- (CGFloat) recordCellHeight;

@end

@interface DetectDataRecordContentView : UIView
{
    UILabel* lbName;
    UILabel* lbUserResult;
    UILabel* lbValue;
    UILabel* lbValueUnit;
}

- (void) setDetectRecord:(DetectRecord*) record;
@end

//血压数值记录
@interface BloodPressureDataRecordContentView : DetectDataRecordContentView

@end

//心率数值记录
@interface HeartRateDataRecordContentView : DetectDataRecordContentView

@end

//体重数值记录
@interface BodyWeightDataRecordContentView : DetectDataRecordContentView

@end

//血糖数值记录
@interface BloodSugarDataRecordContentView : DetectDataRecordContentView

@end


//血脂数值记录
@interface BloodFatDataRecordContentView : DetectDataRecordContentView

@end

//血氧数值记录
@interface BloodOxygenationDataRecordContentView : DetectDataRecordContentView

@end

//尿量数值记录
@interface UrineVolumeDataRecordContentView : DetectDataRecordContentView

@end

//呼吸数值记录
@interface BreathingDataRecordContentView : DetectDataRecordContentView

@end

//体温数值记录
@interface BodyTemperatureDataRecordContentView : DetectDataRecordContentView

@end

//峰流速值记录
@interface PEFDataRecordContentView : DetectDataRecordContentView

@end

