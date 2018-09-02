//
//  FollowPatientTask.m
//  HMDoctor
//
//  Created by Andrew Shen on 2017/3/7.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "FollowPatientTask.h"

@implementation FollowPatientTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postDoctorAttentionServiceURL:@"attentionPatient"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
//    if([stepResult isKindOfClass:[NSArray class]])
//    {
//        NSArray* lspResp = (NSArray*) stepResult;
//        _taskResult = lspResp;
//        return;
//    }
//    
//    _taskErrorMessage = @"接口数据访问失败。";
//    _taskError = StepError_NetwordDataError;
}

@end
