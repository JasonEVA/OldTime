//
//  AdvertiseListTask.m
//  HMDoctor
//
//  Created by yinquan on 2017/6/13.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "AdvertiseListTask.h"
#import "AdvertiseInfo.h"

@implementation AdvertiseListTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postSystemServiceUrl:@"getAdContents"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*)stepResult;
        if (!dicResp || ![dicResp isKindOfClass:[NSDictionary class]])
        {
            _taskError = StepError_NetwordDataError;
            _taskErrorMessage = @"服务器数据访问失败。";
            return;
        }
        NSArray* adList = [dicResp valueForKey:@"ad"];
        if (!adList || ![adList isKindOfClass:[NSArray class]])
        {
            _taskError = StepError_NetwordDataError;
            _taskErrorMessage = @"服务器数据访问失败。";
            return;
        }
        
        NSMutableArray* advertiseItems = [NSMutableArray array];
        for (NSDictionary* dicAdvertise in adList)
        {
            AdvertiseInfo* advetise = [AdvertiseInfo mj_objectWithKeyValues:dicAdvertise];
            [advertiseItems addObject:advetise];
        }
        _taskResult = advertiseItems;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
    
}

@end
