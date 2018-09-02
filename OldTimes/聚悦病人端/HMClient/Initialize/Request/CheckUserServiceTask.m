//
//  CheckUserServiceTask.m
//  HMClient
//
//  Created by yinqaun on 16/7/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "CheckUserServiceTask.h"

@implementation CheckUserServiceTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper posuserServicePoServiceUrl:@"checkUserIsOrderService"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NSString* hasService = [dicResp valueForKey:@"hasService"];
        BOOL userHasService = NO;
        if (hasService && [hasService isKindOfClass:[NSString class]])
        {
            if (0 < hasService.length && [hasService isEqualToString:@"Y"])
            {
                //用户已经订购了服务
                userHasService = YES;
            }
        }
        if (userHasService)
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"Y" forKey:@"hasService"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"N" forKey:@"hasService"];
        }
        
        
        NSString* hasDispatchService = [dicResp valueForKey:@"hasDispatchService"];
        BOOL userHasDispatchService = NO;
        if (hasDispatchService && [hasDispatchService isKindOfClass:[NSString class]])
        {
            if (0 < hasDispatchService.length && [hasDispatchService isEqualToString:@"Y"])
            {
                //用户已经订购了服务
                userHasDispatchService = YES;
            }
        }
        if (userHasDispatchService)
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"Y" forKey:@"hasDispatchService"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setValue:@"N" forKey:@"hasDispatchService"];
        }

        
        NSDictionary* privilege = nil;
        //用户的服务包含内容
        privilege = [dicResp valueForKey:@"privilege"];
        if (privilege)
        {
             [[NSUserDefaults standardUserDefaults] setValue:privilege forKey:@"privilege"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"privilege"];
        }
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        _taskResult = [NSNumber numberWithBool:userHasService];
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
}

@end
