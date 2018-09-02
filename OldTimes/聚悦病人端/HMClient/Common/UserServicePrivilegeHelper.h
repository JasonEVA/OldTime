//
//  UserServicePrivilegeHelper.h
//  HMClient
//
//  Created by yinqaun on 16/8/1.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ServicePrivile_Appoint,     //约诊
    ServicePrivile_HealthPlan,  //健康计划
    ServicePrivile_HealthReport,    //健康报告
    ServicePrivile_HealthDocument,  //健康档案
    ServicePrivile_Conversation,    //图文资讯
} UserServicePrivile;

@interface UserServicePrivilegeHelper : NSObject

+ (BOOL) userHasPrivilege:(UserServicePrivile)privilege;

@end
