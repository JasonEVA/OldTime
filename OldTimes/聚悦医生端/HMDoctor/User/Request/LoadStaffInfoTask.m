//
//  LoadStaffInfoTask.m
//  HMDoctor
//
//  Created by yinqaun on 16/4/20.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "LoadStaffInfoTask.h"

@implementation LoadStaffInfoTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postStaffServiceUrl:@"getStaffInfo"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        //NSDictionary* dicStaff = [dicResp valueForKey:@"staff"];
        if (dicResp && [dicResp isKindOfClass:[NSDictionary class]])
        {
            StaffInfo* staff = [StaffInfo mj_objectWithKeyValues:dicResp];
            
            //[dicResult setValue:staff forKey:@"staff"];
            _taskResult = staff;
        }
    }
}

@end

@implementation UserAuthenticationInfoTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"getUserAuthenticationInfo"];
    return postUrl;
}


@end
