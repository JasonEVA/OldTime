//
//  RoundsTemplateListTask.m
//  HMDoctor
//
//  Created by yinquan on 16/9/18.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "RoundsTemplateListTask.h"
#import "RoundsTemplateModel.h"

@implementation RoundsTemplateListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postassessmentServiceURL:@"getRoundsTemplate"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* items = (NSArray*)stepResult;
        NSArray* array = [RoundsTemplateModel mj_objectArrayWithKeyValuesArray:items];
        
        _taskResult = array;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end

@implementation RoundsTemplateCategoryListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postassessmentServiceURL:@"getRoundsCategory"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* items = (NSArray*)stepResult;
        NSArray* array = [RoundsTemplateCategoryListModel mj_objectArrayWithKeyValuesArray:items];
        if (array && array.count > 0)
        {
            RoundsTemplateCategoryListModel* catemodel = [array firstObject];
            catemodel.isExpanded = YES;
        }
        _taskResult = array;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end
