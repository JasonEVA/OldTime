//
//  AccountExistRequest.m
//  launcher
//
//  Created by williamzhang on 16/4/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "AccountExistRequest.h"
#import "NSDictionary+SafeManager.h"

@implementation AccountExistRequest

- (NSString *)api  { return @"/Base-Module/CompanyUserRegister/GetMailExist"; }
- (NSString *)type { return @"GET"; }

- (void)accountIsExist:(NSString *)account {
    self.params[@"mail"] = account;
    [self requestData];
}

- (BaseResponse *)prepareResponse:(id)data {
    AccountExistResponse *response = [AccountExistResponse new];
    
    response.isExist = [data valueBoolForKey:@"userCount"];
    
    return response;
}

@end

@implementation AccountExistResponse
@end