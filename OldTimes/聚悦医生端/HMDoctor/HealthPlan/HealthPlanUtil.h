//
//  HealthPlanUtil.h
//  HMDoctor
//
//  Created by yinquan on 2017/8/8.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HealthPlanDetModel.h"
#import "HealthPlanTemplateModel.h"
#import "HealthPlanSingleDetectTemplate.h"

#import "HealthPlanViewControllerManager.h"
#import "HealthPlanDetCriteriaModel.h"
#import "HealthDetectWarningSubKpiModel.h"
#import "DetectKPIModel.h"
#import "HealthPlanFillFormTemplateModel.h"
#import "HealthPlanSubTemplateModel.h"
#import "HealthPlanReviewIndicesModel.h"


extern NSString * const kHealthPlanEditedNotificationName;

typedef NS_ENUM(NSUInteger, EHealthPlanOperation) {
    HealthPlanOperation_None,
    HealthPlanOperation_Commit,      //提交
    HealthPlanOperation_Confirm,     //确认
};

typedef NS_ENUM(NSUInteger, PeriodType) {
    PeriodType_Week = 1,
    PeriodType_Day,
    PeriodType_Month,
};

@interface HealthPlanUtil : NSObject

+ (HealthPlanUtil*) shareInstance;

+ (void) postEditNotification;

+ (BOOL) staffHasEditPrivilege:(NSString*) status;


- (NSArray*) targetKpiList:(NSString*) kpiCode;

- (NSArray*) warningKpiList:(NSString*) kpiCode;
@end
