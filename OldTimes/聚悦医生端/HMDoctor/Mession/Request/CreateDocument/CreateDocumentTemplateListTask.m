//
//  CreateDocumentTemplateListTask.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/23.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CreateDocumentTemplateListTask.h"
#import "CreateDocumetnMessionInfo.h"

@implementation CreateDocumentTemplateListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postArchiveTemplateServiceUrl:@"getAllHealthTemplate"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if (stepResult && [stepResult isKindOfClass:[NSArray class]])
    {
        NSArray *array = [CreateDocumetnTemplateModel mj_objectArrayWithKeyValuesArray:stepResult];
        _taskResult = array;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end

@implementation CreateDocumentInitTemplateListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postArchiveTemplateServiceUrl:@"initUserArchiveReport"];
    return postUrl;
}



@end

@implementation CDATemplateSummaryTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postArchiveTemplateServiceUrl:@"getAssessmentSummary"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if (stepResult && [stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        CreateDocumetnMessionInfo* messionModel = [CreateDocumetnMessionInfo mj_objectWithKeyValues:dicResp];
        CreateDocumetnTemplateModel* templateModel = [CreateDocumetnTemplateModel mj_objectWithKeyValues:dicResp];
        NSString* reportStatus = [dicResp valueForKey:@"reportStatus"];
        if (reportStatus && [reportStatus isKindOfClass:[NSString class]])
        {
            messionModel.status = reportStatus.integerValue;
        }
        //userAge
        NSString* userAge = [dicResp valueForKey:@"userAge"];
        if (userAge && [userAge isKindOfClass:[NSString class]])
        {
            messionModel.age = userAge.integerValue;
        }
        
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        if (messionModel)
        {
            [dicResult setValue:messionModel forKey:@"messionModel"];
        }
        if (templateModel)
        {
            [dicResult setValue:templateModel forKey:@"template"];
        }
        
        _taskResult = dicResult;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end