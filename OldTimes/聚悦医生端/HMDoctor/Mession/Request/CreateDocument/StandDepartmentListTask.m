//
//  StandDepartmentListTask.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/23.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "StandDepartmentListTask.h"
#import "CoordinationDepartmentModel.h"
@implementation StandDepartmentListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postArchiveTemplateServiceUrl:@"getStandardDeptBy2Level"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if (stepResult && [stepResult isKindOfClass:[NSArray class]])
    {
        NSArray* lstResp = (NSArray*) stepResult;
        NSMutableArray* departments = [NSMutableArray array];
        
        [lstResp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary* dicDepart = (NSDictionary*) obj;
            CoordinationDepartmentModel* depart = [[CoordinationDepartmentModel alloc] init];
            NSString* standardName = [dicDepart valueForKey:@"standardName"];
            if (standardName && [standardName isKindOfClass:[NSString class]])
            {
                [depart setDepName:standardName];
            }
            
            NSNumber* numDepId = [dicDepart valueForKey:@"standardId"];
            if (numDepId && [numDepId isKindOfClass:[NSNumber class]])
            {
                [depart setDepId:numDepId.integerValue];
            }
            
            [departments addObject:depart];
            
        }];
        _taskResult = departments;
        return;
    }
    
    _taskErrorMessage = @"接口数据访问失败。";
    _taskError = StepError_NetwordDataError;
}
@end
