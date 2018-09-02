//
//  GetTaskTypePageListTask.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/6/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "GetTaskTypePageListTask.h"
#import "MissionListModel.h"

@implementation GetTaskTypePageListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postWorkTaskServiceUrl:@"getTaskTypePageByTabInd"];
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
