//
//  IntegralSourceListTask.m
//  HMClient
//
//  Created by yinquan on 2017/7/17.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "IntegralSourceListTask.h"
#import "IntegralSourceModel.h"

@implementation IntegralSourceListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postIntegralServiceUrl:@"listSource"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* list = (NSArray*) stepResult;
        NSMutableArray* sourceModels = [NSMutableArray array];
        [list enumerateObjectsUsingBlock:^(NSDictionary* sourceDict, NSUInteger idx, BOOL * _Nonnull stop) {
            IntegralSourceModel* model = [IntegralSourceModel mj_objectWithKeyValues:sourceDict];
            [sourceModels addObject:model];
        }];
        
        _taskResult = sourceModels;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}
@end
