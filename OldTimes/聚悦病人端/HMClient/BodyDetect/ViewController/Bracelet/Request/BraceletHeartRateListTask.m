//
//  BraceletHeartRateListTask.m
//  HMClient
//
//  Created by lkl on 2017/10/24.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "BraceletHeartRateListTask.h"
#import "BraceletHeartRateModel.h"

@implementation BraceletHeartRateListTask
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserTestDataService:@"findHeartRateList"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if (stepResult && [stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NSNumber* numCount = [dicResp valueForKey:@"count"];
        NSArray* lstDict = [dicResp valueForKey:@"list"];
        
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        if (numCount && [numCount isKindOfClass:[NSNumber class]])
        {
            [dicResult setValue:numCount forKey:@"count"];
        }
        
        if (lstDict && [lstDict isKindOfClass:[NSArray class]])
        {
            NSMutableArray* records = [NSMutableArray array];

            [lstDict enumerateObjectsUsingBlock:^(NSDictionary *dicRecord, NSUInteger idx, BOOL * _Nonnull stop) {
                BraceletHeartRateModel *model = [BraceletHeartRateModel mj_objectWithKeyValues:dicRecord];
                [records addObject:model];
            }];
            [dicResult setValue:records forKey:@"list"];
        }
        _taskResult = dicResult;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end
