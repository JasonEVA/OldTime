//
//  NewMissionGetTeamTaskListRequest.m
//  HMDoctor
//
//  Created by jasonwang on 16/8/5.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "NewMissionGetTeamTaskListRequest.h"
#import "MissionListModel.h"

@implementation NewMissionGetTeamTaskListRequest

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postWorkTaskServiceUrl:@"getTeamTaskList"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]]) {
        MissionListModel *model = [MissionListModel mj_objectWithKeyValues:stepResult];
        _taskResult = model;
    }
}
@end
