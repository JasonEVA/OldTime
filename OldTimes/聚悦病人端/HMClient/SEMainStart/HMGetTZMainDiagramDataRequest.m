//
//  HMGetTZMainDiagramDataRequest.m
//  HMClient
//
//  Created by jasonwang on 2017/8/8.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMGetTZMainDiagramDataRequest.h"
#import "HMTZMainDiagramDataModel.h"

@implementation HMGetTZMainDiagramDataRequest
- (NSString*)postUrl
{
    NSString* postUrl = [ClientHelper postExerciseService:@"getTZMainDiagramData"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]] && stepResult) {
        HMTZMainDiagramDataModel *result = [HMTZMainDiagramDataModel mj_objectWithKeyValues:stepResult];
        _taskResult = result;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}
@end
