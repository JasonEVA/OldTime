//
//  UserServicePrivilegeHelper.m
//  HMClient
//
//用户服务涉及权限的判断
//
//  Created by yinqaun on 16/8/1.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "UserServicePrivilegeHelper.h"

@implementation UserServicePrivilegeHelper

/*
 ServicePrivile_Appoint,     //约诊
 ServicePrivile_HealthPlan,  //健康计划
 ServicePrivile_HealthDocument,  //健康档案
 ServicePrivile_Conversation,    //图文资讯
 */

+ (NSString*) userHasPrivilegeString:(UserServicePrivile)privilege
{
    NSString* privilegeStr = nil;
    switch (privilege)
    {
        case ServicePrivile_Appoint:
        {
            //约诊
            privilegeStr = @"YZ";
        }
            break;
        case ServicePrivile_HealthPlan:
        {
            //健康计划
            privilegeStr = @"JKJH";
        }
            break;
        case ServicePrivile_HealthReport:
        {
            //健康报告
            privilegeStr = @"JKBG";
        }
            break;
        case ServicePrivile_HealthDocument:
        {
            //健康档案
            privilegeStr = @"JKDA";
        }
            break;
        case ServicePrivile_Conversation:
        {
            //图文资讯
            privilegeStr = @"TWZX";
        }
            break;
        default:
            break;
    }
    return privilegeStr;
}

+ (BOOL) userHasPrivilege:(UserServicePrivile)privilege
{
    NSString* privilegeStr = [self userHasPrivilegeString:privilege];
    if(!privilegeStr)
    {
        return NO;
    }
    
    NSDictionary* dicPrivilege = [[NSUserDefaults standardUserDefaults] valueForKey:@"privilege"];
    if(!dicPrivilege || ![dicPrivilege isKindOfClass:[NSDictionary class]])
    {
        return NO;
    }
    
    NSString* privilegeValue = [dicPrivilege valueForKey:privilegeStr];
    if(privilegeValue && [privilegeValue isKindOfClass:[NSString class]] && 0 < privilegeValue.length)
    {
        return YES;
    }
    return NO;
}

@end
