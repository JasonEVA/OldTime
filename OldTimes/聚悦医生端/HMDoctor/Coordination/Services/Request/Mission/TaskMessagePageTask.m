//
//  TaskMessagePageTask.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/6/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "TaskMessagePageTask.h"
#import "MissionCommentsModel.h"

@implementation TaskMessagePageTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postWorkTaskServiceUrl:@"taskMessagePage"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]]) {
        MissionCommentListModel *model = [MissionCommentListModel mj_objectWithKeyValues:stepResult];
        _taskResult = model;
    }
}

@end
