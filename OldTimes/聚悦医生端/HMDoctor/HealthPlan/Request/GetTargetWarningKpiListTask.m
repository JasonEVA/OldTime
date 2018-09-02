//
//  GetTargetWarningKpiListTask.m
//  HMDoctor
//
//  Created by yinquan on 2017/9/21.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "GetTargetWarningKpiListTask.h"

@implementation GetTargetWarningKpiListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postHealthyPlanServiceServiceUrl:@"getHasTargetAndWarningKpiList"];
    return postUrl;
}

- (void) makeTaskResult
{
    _taskResult = currentStep.stepResult;
}
@end
