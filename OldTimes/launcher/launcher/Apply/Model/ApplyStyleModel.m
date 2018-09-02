//
//  ApplyStyleModel.m
//  launcher
//
//  Created by conanma on 15/11/5.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ApplyStyleModel.h"
#import "NSDictionary+SafeManager.h"

static NSString *const m_showid         = @"SHOW_ID";
static NSString *const m_name           = @"T_NAME";
static NSString *const m_des            = @"T_DES";
static NSString *const m_default        = @"IS_DEFAULT";
static NSString *const m_createuser     = @"CREATE_USER";
static NSString *const m_createusername = @"CREATE_USER_NAME";
static NSString *const m_createtime     = @"CREATE_TIME";
static NSString *const m_status         = @"T_STATUS";
static NSString *const m_workflowid     = @"T_WORKFLOW_ID";
static NSString *const m_FORM_ID        = @"FORM_ID";

@implementation ApplyStyleModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (dict)
    {
        self.showid         = [dict valueStringForKey:m_showid];
        self.name           = [dict valueStringForKey:m_name];
        self.des            = [dict valueStringForKey:m_des];
        self.def            = [[dict valueNumberForKey:m_default] integerValue];
        self.status         = [[dict valueNumberForKey:m_status] integerValue];
        self.createUser     = [dict valueStringForKey:m_createuser];
        self.createUserName = [dict valueStringForKey:m_createusername];
        self.createTime     = [[dict valueNumberForKey:m_createtime] longLongValue];
        self.T_WORKFLOW_ID  = [dict valueStringForKey:m_workflowid];
        self.FORM_ID        = [dict valueStringForKey:m_FORM_ID];
    }
    return self;
}


@end
