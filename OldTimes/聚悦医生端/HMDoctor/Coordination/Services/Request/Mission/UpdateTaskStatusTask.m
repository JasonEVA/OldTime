//
//  UpdateTaskStatusTask.m
//  HMDoctor
//
//  Created by Dee on 16/6/10.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "UpdateTaskStatusTask.h"

@implementation UpdateTaskStatusTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postWorkTaskServiceUrl:@"updateTaskStatus"];
    return postUrl;
}

- (void)makeTaskResult
{
    //处理返回的参数
    id stepReslt = currentStep.stepResult;
    if ([stepReslt isKindOfClass:[NSArray class]])
    {
        
    }
}

@end
