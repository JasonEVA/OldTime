//
//  UserHealthTargetListTask.m
//  HMClient
//
//  Created by yinqaun on 16/6/21.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UserHealthTargetListTask.h"
#import "MainStartHealthTarget.h"

@implementation UserHealthTargetListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postHealthPlan2Service:@"getUserTestTarget"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        
        NSArray* lstResp = (NSArray*) stepResult;
        NSMutableArray* targets = [NSMutableArray array];
        for (NSDictionary* dicTarget in lstResp)
        {
            MainStartHealthTarget* target = [MainStartHealthTarget mj_objectWithKeyValues:dicTarget];
            [targets addObject:target];
        }
        _taskResult = targets;

        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}
@end
