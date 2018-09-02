//
//  CDAHealthTemplateTypeListTask.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/24.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CDAHealthTemplateTypeListTask.h"
#import "CreateDocumetnMessionInfo.h"

@implementation CDAHealthTemplateTypeListTask

- (NSString*) postUrl
{
//    NSString* postUrl = [ClientHelper postArchiveTemplateServiceUrl:@"getHealthTemplateType"];
    NSString* postUrl = [ClientHelper postArchiveTemplateServiceUrl:@"getAssessmentSummary"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if (stepResult && [stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NSArray* summaryDetails = dicResp[@"summaryDetails"];
        if (!summaryDetails || ![summaryDetails isKindOfClass:[NSArray class]])
        {
            _taskErrorMessage = @"接口数据访问失败。";
            _taskError = StepError_NetwordDataError;
            return;
        }
        //summaryDetails
        NSArray *array = [CreateDocumetnTemplateTypeModel mj_objectArrayWithKeyValuesArray:summaryDetails];
        _taskResult = array;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end
