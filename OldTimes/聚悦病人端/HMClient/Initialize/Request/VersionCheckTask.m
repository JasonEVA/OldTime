//
//  VersionCheckTask.m
//  HMClient
//
//  Created by yinqaun on 16/6/23.
//  Copyright © 2016年 YinQ. All rights reserved.
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
