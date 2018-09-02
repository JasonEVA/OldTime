//
//  UserLoginTask.m
//  HMDoctor
//
//  Created by yinquan on 16/4/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "UserLoginTask.h"

@implementation UserLoginTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"staffLogin"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        //VersionUpdateInfo* verInfo = [VersionUpdateInfo mj_objectWithKeyValues:dicResp];
        //_taskResult = verInfo;
        NSMutableDictionary* dicResult = [NSMutableDictionary dictionary];
        
        NSDictionary* dicStaff = [dicResp valueForKey:@"staff"];
        if (dicStaff && [dicStaff isKindOfClass:[NSDictionary class]])
        {
            StaffInfo* staff = [StaffInfo mj_objectWithKeyValues:dicStaff];
            [[UserInfoHelper defaultHelper] saveStaffInfo:staff];
            [dicResult setValue:staff forKey:@"staff"];
        }
        
        NSDictionary* dicUser = [dicResp valueForKey:@"user"];
        if (dicUser && [dicUser isKindOfClass:[NSDictionary class]])
        {
            UserInfo* user = [UserInfo mj_objectWithKeyValues:dicUser];
            [[UserInfoHelper defaultHelper] saveUserInfo:user];
            [dicResult setValue:user forKey:@"user"];
        }
        
        NSString* staffRole = [dicResp valueForKey:@"staffRole"];
        if (staffRole && [staffRole isKindOfClass:[NSString class]])
        {
            //角色
            [[UserInfoHelper defaultHelper] setStaffRole:staffRole];
        }
        
    }
    
}


@end
