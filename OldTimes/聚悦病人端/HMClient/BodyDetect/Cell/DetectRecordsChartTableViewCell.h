//
//  DetectRecordsChartTableViewCell.h
//  HMClient
//
//  Created by yinqaun on 16/5/3.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DetectRecords_PregnancyBodyWeight,
    DetectRecords_BloodPressure,
    DetectRecords_ECG,
    
    DetectRecords_BodyWeight,
    DetectRecords_BloodSugar,
    DetectRecords_BloodFat,
    DetectRecords_UrineVolume,
    DetectRecords_BloodOxygen,
    DetectRecords_Breathing,
    DetectRecords_BodyTemperature,
    DetectRecords_TypeCount,
} DetectRecordsType;

typedef enum : NSUInteger {
    ConstrastRecords_SystolicPressure,
    ConstrastRecords_DiastolicPressure,
    ConstrastRecords_ECG,
    ConstrastRecords_BodyWeight,
    ConstrastRecords_BloodSugar,
    ConstrastRecords_BloodFat,
    ConstrastRecords_UrineVolume,
    ConstrastRecords_BloodOxygen,
    ConstrastRecords_Breathing,
    ConstrastRecords_TypeCount,
} ConstrastDetectRecordsType;

@interface DetectRecordsChartTableViewCell : UITableViewCell
{
    UIWebView* webview;
    UIControl* clickcontrol;
}

@property (nonatomic, retain) NSString* userId;
@property (nonatomic, retain) NSString* targetControllerName;

- (void) loadChartWithUrl:(NSString*) chartUrl;
@end

@interface BodyWeightDetectRecordsChartTableViewCell : DetectRecordsChartTableViewCell

@end

@interface BloodSugarConstastRecordsChartTableViewCell : DetectRecordsChartTableViewCell

@end

@interface BloodPressureDetectRecordsChartTableViewCell : DetectRecordsChartTableViewCell

@end

