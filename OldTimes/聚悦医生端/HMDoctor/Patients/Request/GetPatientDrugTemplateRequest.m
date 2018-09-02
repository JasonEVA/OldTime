//
//  GetPatientDrugTemplateRequest.m
//  HMDoctor
//
//  Created by jasonwang on 16/8/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "GetPatientDrugTemplateRequest.h"
#import "DrugUseTemplateListModel.h"
#import <MJExtension/MJExtension.h>
@implementation GetPatientDrugTemplateRequest
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postHealthPlan2ServiceServiceUrl:@"getHealtyPlanTemplate"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if([stepResult isKindOfClass:[NSArray class]])
    {
        _taskResult = [DrugUseTemplateListModel mj_objectArrayWithKeyValuesArray:stepResult];
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
