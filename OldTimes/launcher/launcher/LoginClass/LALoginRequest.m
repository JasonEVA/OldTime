//
//  LALoginRequest.m
//  launcher
//
//  Created by William Zhang on 15/8/20.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "LALoginRequest.h"
#import "LALoginResultModel.h"

static NSString *const d_userLoginName = @"userLoginName";
static NSString *const d_userPassword  = @"userPassword";

@implementation LALoginResponse
@end

@implementation LALoginRequest

- (void)loginName:(NSString *)loginName password:(NSString *)password {
    // 暂不加密
    self.params[d_userLoginName] = loginName;
    self.params[d_userPassword]  = password;
    [self requestData];
}

- (NSString *)api {
    return @"/Base-Module/CompanyUserLogin";
}

- (BaseResponse *)prepareResponse:(id)data {
    LALoginResponse *response = [LALoginResponse new];

    response.resultModel = [[LALoginResultModel alloc] initWithDict:data];
    
    return response;
}

@end
