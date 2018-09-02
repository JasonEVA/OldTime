//
//  HMGetDiagramDataRequest.m
//  HMClient
//
//  Created by jasonwang on 2017/7/6.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMGetDiagramDataRequest.h"

@implementation HMGetDiagramDataRequest
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postMonitorService:@"getDiagramData"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        _taskError = StepError_None;
        _taskResult = dicResp;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end
