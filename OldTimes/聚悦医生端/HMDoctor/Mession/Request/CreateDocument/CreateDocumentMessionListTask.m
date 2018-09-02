//
//  CreateDocumentMessionListTask.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/22.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CreateDocumentMessionListTask.h"
#import "CreateDocumetnMessionInfo.h"

@implementation CreateDocumentMessionListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postAssessmentServiceUrl:@"getUserFileAssessment"];
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
        NSMutableArray* messions = [NSMutableArray array];
        
        if (list && [list isKindOfClass:[NSArray class]])
        {
            [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSDictionary class]])
                {
                    NSDictionary* dicMession = (NSDictionary*) obj;
                    CreateDocumetnMessionInfo* mession = [CreateDocumetnMessionInfo mj_objectWithKeyValues:dicMession];
                    [messions addObject:mession];
                }
                
            }];
        }
        
        if (numCount)
        {
            [dicResult setValue:numCount forKey:@"count"];
        }
        [dicResult setValue:messions forKey:@"list"];
        _taskResult = dicResult;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end

@implementation CreateDocumentMessionListCountTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postAssessmentServiceUrl:@"getUserFileAssessmentCount"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if([stepResult isKindOfClass:[NSNumber class]])
    {
        
        _taskResult = stepResult;
        return;
    }
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}

@end
