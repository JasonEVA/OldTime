//
//  HealthyEducationColumesTask.m
//  HMDoctor
//
//  Created by yinquan on 17/1/6.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthyEducationColumesTask.h"
#import "HealthEducationItem.h"

@implementation HealthyEducationColumesTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postMcClassServiceUrl:@"findClassTypeList"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if (stepResult && [stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lstResp = (NSArray*)stepResult;
        NSMutableArray* columes = [NSMutableArray array];
        
        [lstResp enumerateObjectsUsingBlock:^(NSDictionary* dicCol, NSUInteger idx, BOOL * _Nonnull stop) {
            HealthyEducationColumeModel* model = [HealthyEducationColumeModel mj_objectWithKeyValues:dicCol];
            [columes addObject:model];
        }];
        
        _taskError = StepError_None;
        _taskResult = columes;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
