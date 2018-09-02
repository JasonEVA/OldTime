//
//  LALoginResultModel.m
//  launcher
//
//  Created by William Zhang on 15/8/20.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "LALoginResultModel.h"
#import "NSDictionary+SafeManager.h"

static NSString *const d_u_show_id        = @"U_SHOW_ID";
static NSString *const d_last_login_token = @"LAST_LOGIN_TOKEN";
static NSString *const d_u_true_name      = @"U_TRUE_NAME";
static NSString *const d_u_name           = @"U_NAME";
static NSString *const d_c_show_id        = @"C_SHOW_ID";
static NSString *const d_c_code           = @"C_CODE";

@implementation LALoginResultModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.userShowId     = [dict valueStringForKey:d_u_show_id];
        self.lastLoginToken = [dict valueStringForKey:d_last_login_token];
        self.userTrueName   = [dict valueStringForKey:d_u_true_name];
        self.userName       = [dict valueStringForKey:d_u_name];
        
        self.companyShowId = [dict valueStringForKey:d_c_show_id];
        self.companyCode   = [dict valueStringForKey:d_c_code];
    }
    return self;
}

@end
