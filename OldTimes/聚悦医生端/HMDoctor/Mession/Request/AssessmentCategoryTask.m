//
//  AssessmentCategoryTask.m
//  HMDoctor
//
//  Created by lkl on 16/8/30.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "AssessmentCategoryTask.h"

@implementation AssessmentCategoryTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postassessmentServiceURL:@"getAssessmentCategory"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lspResp = (NSArray*) stepResult;
        _taskResult = lspResp;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
