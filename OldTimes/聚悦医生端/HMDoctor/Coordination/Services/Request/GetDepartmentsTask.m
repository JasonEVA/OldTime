//
//  GetDepartmentsTask.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/5/31.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "GetDepartmentsTask.h"
#import "CoordinationDepartmentModel.h"

@implementation GetDepartmentsTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postDepServiceUrl:@"getDepByOrgId"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray *array = [CoordinationDepartmentModel mj_objectArrayWithKeyValuesArray:stepResult];
        _taskResult = array;
    }
    
}

@end
