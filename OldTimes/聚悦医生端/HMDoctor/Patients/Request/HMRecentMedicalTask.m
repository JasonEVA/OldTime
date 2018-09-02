//
//  HMRecentMedicalTask.m
//  HMDoctor
//
//  Created by lkl on 2017/3/17.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMRecentMedicalTask.h"
#import "HMGetCheckImgListModel.h"
#import "HMRecentMedicalModel.h"

@implementation HMRecentMedicalTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postadmissionAssessAppService:@"getRecentDrug"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray *array = [HMRecentMedicalModel mj_objectArrayWithKeyValuesArray:stepResult];
        _taskResult = array;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end


@implementation getCheckImgListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postadmissionAssessAppService:@"getCheckImgList"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray *array = [HMGetCheckImgListModel mj_objectArrayWithKeyValuesArray:stepResult];
        _taskResult = array;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end

@implementation getCheckItemTypeTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postadmissionAssessAppService:@"getCheckItemType"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray *array = [CheckItemTypeModel mj_objectArrayWithKeyValuesArray:stepResult];
        _taskResult = array;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end


@implementation getCheckDetailTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postadmissionAssessAppService:@"getCheckDetail"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;

    if (stepResult && [stepResult isKindOfClass:[NSDictionary class]]) {
 
        CheckItemDetailModel *detailModel = [CheckItemDetailModel mj_objectWithKeyValues:stepResult];
        _taskResult = detailModel;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
