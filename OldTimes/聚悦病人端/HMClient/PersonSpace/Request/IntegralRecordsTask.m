//
//  IntegralRecordsTask.m
//  HMClient
//
//  Created by yinquan on 2017/7/14.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "IntegralRecordsTask.h"
#import "IntegralRecordModel.h"

@implementation IntegralRecordsTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postIntegralServiceUrl:@"getUserIntegralMonthInfo"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if (!stepResult || ([stepResult isKindOfClass:[NSString class]] && [stepResult isEqualToString:@""])) {
        stepResult = [NSArray array];
    }
    
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* list = (NSArray*) stepResult;
        NSMutableArray* monthModels = [NSMutableArray array];
        [list enumerateObjectsUsingBlock:^(NSDictionary* monthDict, NSUInteger idx, BOOL * _Nonnull stop) {
            IntegralMonthRecordModel* model = [IntegralMonthRecordModel mj_objectWithKeyValues:monthDict];
            [monthModels addObject:model];
        }];
        
        _taskResult = monthModels;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}
@end
