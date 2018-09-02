//
//  HealthPlanDetCriteriaModel.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthPlanDetCriteriaModel : NSObject

@property (nonatomic, retain) NSString* planId;
@property (nonatomic, retain) NSString* periodType;
@property (nonatomic, retain) NSString* periodValue;
@property (nonatomic, readonly) NSString* periodTypeString;
@property (nonatomic, readonly) NSString* mentalityPeriodTypeString;
@property (nonatomic, readonly) NSString* periodString;
@property (nonatomic, readonly) NSString* mentalityPeriodString;
@property (nonatomic, retain) NSString* sortIndex;

@property (nonatomic, retain) NSString* kpiCode;
@property (nonatomic, retain) NSString* kpiId;
@property (nonatomic, retain) NSString* kpiTitle;
@property (nonatomic, retain) NSArray* alertTimes;
@property (nonatomic, retain) NSArray* testTargets;
@property (nonatomic, retain) NSArray* warnings;

@property (nonatomic, retain) NSString* surveyMoudleName;
@property (nonatomic, retain) NSString* surveyMoudleId;

@property (nonatomic, retain) NSString* suggest;
@property (nonatomic, retain) NSString* target;

@property (nonatomic, retain) NSString* sportsTimes;
@property (nonatomic, retain) NSArray* sportType;
@property (nonatomic, retain) NSString* exerciseIntensity;

@property (nonatomic, retain) NSString* indicesName;
@property (nonatomic, retain) NSString* indicesCode;

@property (nonatomic, retain) NSString* drugName;
@property (nonatomic, retain) NSString* drugUseDay;
@property (nonatomic, retain) NSString* drugsFrequencyName;
@property (nonatomic, retain) NSString* drugsUsageName;
@property (nonatomic, retain) NSString* singleDosage;
@property (nonatomic, retain) NSString* singleUnit;


- (NSString*) detectTargetString;
- (NSString*) detectAlertTimesString;
//运动强度
- (NSString*) sportStrength;
 
//监测单位
- (NSString*) detectUnitText;

//监测的目标值是否合法
- (BOOL) detectTargetsIsValid;

//监测的频率、提醒时间是否合法
- (BOOL) detectAlertIsValid;

//监测的预警值是否合法
- (BOOL) detectWarningIsValid;

//随访、查房、评估是否合法
- (BOOL) fillFormIsValid;

//复查计划是否合法
- (BOOL) reviewIsValid;
@end

@interface HealthDetectPlanAlertModel : NSObject

@property (nonatomic, retain) NSString* alertCon;
@property (nonatomic, retain) NSString* alertTime;
@property (nonatomic, retain) NSString* testAlertId;
@property (nonatomic, retain) NSString* testPlanDetId;

@end

@interface HealthDetectPlanTargetModel : NSObject

@property (nonatomic, retain) NSString* kpiName;
@property (nonatomic, retain) NSString* subKpiId;
@property (nonatomic, retain) NSString* subKpiCode;
@property (nonatomic, retain) NSString* targetId;
@property (nonatomic, retain) NSString* targetValue;
@property (nonatomic, retain) NSString* targetSymbol;
@property (nonatomic, retain) NSString* targetMaxValue;
@property (nonatomic, retain) NSString* testPlanDetId;
@property (nonatomic, retain) NSString* unit;


- (NSString*) targetValueString;
@end

typedef NS_ENUM(NSUInteger, HealthDetectWarningType) {
    WarningType_Unknown,
    WarningType_High,
    WarningType_Low,
    WarningType_Custom,
};

@interface HealthDetectPlanWarningModel : NSObject

@property (nonatomic, assign) NSInteger alertGrade;
@property (nonatomic, retain) NSString* alertResultGrade;
@property (nonatomic, retain) NSString* doctorAlertCon;
@property (nonatomic, assign) NSInteger kpiId;
@property (nonatomic, retain) NSString* signsId;


@property (nonatomic, retain) NSString* oneKpiCode;
@property (nonatomic, retain) NSString* oneKpiName;
@property (nonatomic, assign) NSInteger oneKpiId;
@property (nonatomic, retain) NSString* oneBeginValue;
@property (nonatomic, retain) NSString* oneBeginSymbol;
@property (nonatomic, retain) NSString* oneEndValue;
@property (nonatomic, retain) NSString* oneEndSymbol;

@property (nonatomic, retain) NSString* oneTwoRelation;

@property (nonatomic, retain) NSString* twoKpiCode;
@property (nonatomic, retain) NSString* twoKpiName;
@property (nonatomic, assign) NSInteger twoKpiId;
@property (nonatomic, retain) NSString* twoBeginValue;
@property (nonatomic, retain) NSString* twoBeginSymbol;
@property (nonatomic, retain) NSString* twoEndValue;
@property (nonatomic, retain) NSString* twoEndSymbol;

@property (nonatomic, retain) NSString* sortRank;
@property (nonatomic, retain) NSString* surveyMoudleId;
@property (nonatomic, retain) NSString* testPlanDetId;
@property (nonatomic, retain) NSString* testRuleId;
@property (nonatomic, retain) NSString* testTempDetId;
@property (nonatomic, retain) NSString* userAlertResult;
@property (nonatomic, retain) NSString* userHealthySuggest;

- (NSString*) warningString;

- (HealthDetectWarningType) warningIdentificationType;
- (NSString*) warningIdentificationTypeString;
@end

@interface HealthSportTypeModel : NSObject

@property (nonatomic, retain) NSString* sportsName;
@property (nonatomic, retain) NSString* sportsTypeId;

@end
