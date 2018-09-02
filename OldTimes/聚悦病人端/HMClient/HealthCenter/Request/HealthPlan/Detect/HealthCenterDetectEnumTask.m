//
//  HealthCenterDetectEnumTask.m
//  HMClient
//
//  Created by yinqaun on 16/7/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "HealthCenterDetectEnumTask.h"
#import "RecordHealthInfo.h"

@implementation HealthCenterDetectEnumTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postHealthPlan2Service:@"getUserHealthyBaseTest"];
    return postUrl;
}


- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lstResp = (NSArray*) stepResult;
        NSMutableArray* detects = [NSMutableArray array];
        for (NSDictionary* dicGroup in lstResp)
        {
            DeviceDetectRecord* group = [DeviceDetectRecord mj_objectWithKeyValues:dicGroup];
            [detects addObject:group];
        }
        _taskResult = detects;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end
