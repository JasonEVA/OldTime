//
//  SurveyMoudlesTask.m
//  HMDoctor
//
//  Created by yinqaun on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "SurveyMoudlesTask.h"
#import "SurveyRecord.h"

@implementation SurveyMoudlesTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postSurveryServiceUrl:@"searchSurveyMoudles"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lstResp = (NSArray*) stepResult;
        NSMutableArray* groups = [NSMutableArray array];
        for (NSDictionary* dicGroups in lstResp)
        {
            SurveryMoudleGroup* group = [SurveryMoudleGroup mj_objectWithKeyValues:dicGroups];
            [groups addObject:group];
        }
        
        _taskResult = groups;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end

@implementation PostSurveyMoudlesTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postSurveryServiceUrl:@"pushSurveys"];
    return postUrl;
}

@end