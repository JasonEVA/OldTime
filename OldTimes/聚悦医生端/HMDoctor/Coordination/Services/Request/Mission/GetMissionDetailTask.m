//
//  GetMissionDetailTask.m
//  HMDoctor
//
//  Created by Dee on 16/6/14.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "GetMissionDetailTask.h"
#import "MissionDetailModel.h"

@implementation GetMissionDetailTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postWorkTaskServiceUrl:@"getTask"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        MissionDetailModel *model = [MissionDetailModel mj_objectWithKeyValues:stepResult];
        _taskResult = model;
    }
    
}


@end
