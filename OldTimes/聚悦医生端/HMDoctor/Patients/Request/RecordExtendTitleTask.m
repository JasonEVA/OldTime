//
//  RecordExtendTitleTask.m
//  HMDoctor
//
//  Created by lkl on 2017/7/10.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "RecordExtendTitleTask.h"
#import "RecordExtendTitleModel.h"

@implementation RecordExtendTitleTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserChartService:@"getExtRecordTitle"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray *array = [RecordExtendTitleModel mj_objectArrayWithKeyValuesArray:stepResult];
        _taskResult = array;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end


@implementation AsthmaDiaryTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserChartService:@"getAsthmaDiary"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray *array = [AsthmaDiaryModel mj_objectArrayWithKeyValuesArray:stepResult];
        _taskResult = array;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
