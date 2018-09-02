//
//  VersionCheckTask.m
//  HMDoctor
//
//  Created by yinquan on 16/4/11.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "VersionCheckTask.h"
#import "VersionUpdateInfo.h"
@implementation VersionCheckTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postSystemServiceUrl:@"getVersion"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        VersionUpdateInfo* verInfo = [VersionUpdateInfo mj_objectWithKeyValues:dicResp];
        _taskResult = verInfo;
        
    }

}

@end

@implementation PicServierPathTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postSystemServiceUrl:@"getPicServcerPath"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSString class]])
    {
        _taskResult = stepResult;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}


@end