//
//  SurveyRecordTask.m
//  HMClient
//
//  Created by lkl on 16/5/25.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SurveyRecordTask.h"
#import "SurveyRecord.h"
@implementation SurveyRecordTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postSurveryServiceUrl:@"getSurveyRecordByPage"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;

    if([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NSNumber* numCount = [dicResp valueForKey:@"count"];
        NSArray* list = [dicResp valueForKey:@"list"];
        NSMutableArray* records = [NSMutableArray array];
        
        if (list && [list isKindOfClass:[NSArray class]])
        {
            for (NSDictionary* dicRecord in list)
            {
                
                SurveyRecord* record = [SurveyRecord mj_objectWithKeyValues:dicRecord];
                
                [records addObject:record];
            }
        }
        if (numCount)
        {
            [dicResult setValue:numCount forKey:@"count"];
        }
        [dicResult setValue:records forKey:@"list"];
        _taskResult = dicResult;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end

@implementation SurveyPaperTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postSurveryServiceUrl:@"getSurveyPaperByMoudleId"];
    return postUrl;
}

@end

@implementation SurveyRecordInfoTask

- (NSString*) postUrl
{
    NSString*postUrl = [ClientHelper postSurveryServiceUrl:@"getSurveyRecordInfo"];
    return postUrl;
}

@end



