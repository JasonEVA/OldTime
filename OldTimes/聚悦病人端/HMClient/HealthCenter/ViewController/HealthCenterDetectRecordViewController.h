//
//  HealthCenterDetectRecordViewController.h
//  HMClient
//
//  Created by yinqaun on 16/6/6.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterDetectDegreeView.h"

@interface HealthCenterDetectRecordViewController : UIViewController
{
    CenterDetectDegreeView* degreeview;
    UILabel* lbKpiName;
    UILabel* lbDetectValue;
    UILabel* lbDetectUnit;
}
@property (nonatomic, readonly) NSString* kpiCode;

- (id) initWithKpiCode:(NSString*) code;
@end

@interface HealthCenterBloodPressureDetectRecordViewController : HealthCenterDetectRecordViewController

@end

@interface HealthCenterHeartRateDetectRecordViewController : HealthCenterDetectRecordViewController

@end


@interface HealthCenterBodyWeightDetectRecordViewController : HealthCenterDetectRecordViewController

@end

@interface HealthCenterBloodSugarDetectRecordViewController : HealthCenterDetectRecordViewController

@end

@interface HealthCenterBloodFatDetectRecordViewController : HealthCenterDetectRecordViewController

@end


@interface HealthCenterBloodOxygenationDetectRecordViewController : HealthCenterDetectRecordViewController

@end


@interface HealthCenterUrineVolumeDetectRecordViewController : HealthCenterDetectRecordViewController

@end


@interface HealthCenterBreathingDetectRecordViewController : HealthCenterDetectRecordViewController

@end