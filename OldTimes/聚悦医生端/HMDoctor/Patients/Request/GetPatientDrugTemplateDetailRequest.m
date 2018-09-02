//
//  GetPatientDrugTemplateDetailRequest.m
//  HMDoctor
//
//  Created by jasonwang on 16/8/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "GetPatientDrugTemplateDetailRequest.h"
#import "DrugUseTemplateDetailModel.h"

@implementation GetPatientDrugTemplateDetailRequest
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postcommonHealthyPlanService:@"getMedicinePlanTempDet"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if([stepResult isKindOfClass:[NSArray class]])
    {
        _taskResult = [DrugUseTemplateDetailModel mj_objectArrayWithKeyValuesArray:stepResult];
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
