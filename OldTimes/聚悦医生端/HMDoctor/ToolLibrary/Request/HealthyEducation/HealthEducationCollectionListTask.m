//
//  HealthEducationCollectionListTask.m
//  HMDoctor
//
//  Created by yinquan on 17/1/7.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthEducationCollectionListTask.h"
#import "HealthEducationItem.h"

@implementation HealthEducationCollectionListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postMcClassServiceUrl:@"getMcClassUserFavorList"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if (stepResult && [stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dicResp = (NSDictionary *)stepResult;
        NSArray* lstResp = dicResp[@"list"];
        NSMutableArray* columes = [NSMutableArray array];
        
        [lstResp enumerateObjectsUsingBlock:^(NSDictionary* dicCol, NSUInteger idx, BOOL * _Nonnull stop) {
            HealthEducationItem *collectItem = [HealthEducationItem mj_objectWithKeyValues:dicCol];
            [columes addObject:collectItem];
        }];
        
        _taskError = StepError_None;
        _taskResult = columes;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end

@implementation CheckUserClassHasCollectTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postMcClassServiceUrl:@"checkUserClassHasCollect"];
    return postUrl;
}

@end

@implementation addCollectTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postMcClassServiceUrl:@"addCollect"];
    return postUrl;
}

@end

@implementation cancelCollectTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postMcClassServiceUrl:@"cancelCollect"];
    return postUrl;
}

@end
