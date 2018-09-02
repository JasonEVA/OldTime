//
//  HealthPlanAllDetectTask.m
//  HMDoctor
//
//  Created by yinquan on 2017/8/23.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanAllDetectTask.h"

@implementation HealthPlanAllDetectTask

- (NSString*) postUrl
{
    NSString *postUrl = [ClientHelper postUserTestRelationService:@"getUserTestRecoderHealthy"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        
        NSArray *testRecodHealthArray = [dicResp valueForKey:@"userTestRecoderHealthys"];
        NSMutableArray* testRecodHealthItems = [NSMutableArray array];
        
        if (testRecodHealthArray && [testRecodHealthArray isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicTestRecod in testRecodHealthArray)
            {
                DetectKPIModel *info = [DetectKPIModel mj_objectWithKeyValues:dicTestRecod];
                [testRecodHealthItems addObject:info];
            }
        }
        
        
        _taskResult = testRecodHealthItems;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
