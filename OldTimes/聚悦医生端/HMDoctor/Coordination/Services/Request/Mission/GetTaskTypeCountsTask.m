//
//  GetTaskTypeCountsTask.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/6/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "GetTaskTypeCountsTask.h"
#import "TaskTypeTitleAndCountModel.h"
#import "NewMissionGroupModel.h"

@implementation GetTaskTypeCountsTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postWorkTaskServiceUrl:@"getTaskTypeCounts"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if ([stepResult isKindOfClass:[NSDictionary class]]) {
        NSArray *arrayResults = [TaskTypeTitleAndCountModel mj_objectArrayWithKeyValuesArray:stepResult[@"baseGroup"]];
        NSArray *teamArr = [NewMissionGroupModel mj_objectArrayWithKeyValuesArray:stepResult[@"teamGroup"]];
        _taskResult = @[arrayResults,teamArr];
    }
}
@end
