//
//  OftenIllnessListTask.m
//  HMClient
//
//  Created by yinqaun on 16/5/5.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "OftenIllnessListTask.h"
#import "UserOftenIllInfo.h"

@implementation OftenIllnessListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postGuideServiceUrl:@"getJbIllnessByOften"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lstResp = (NSArray*) stepResult;
        NSMutableArray* ills = [NSMutableArray array];
        for (NSDictionary* dicIll in lstResp)
        {
            UserOftenIllInfo* item = [UserOftenIllInfo mj_objectWithKeyValues:dicIll];
            [ills addObject:item];
        }
        _taskResult = ills;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end
