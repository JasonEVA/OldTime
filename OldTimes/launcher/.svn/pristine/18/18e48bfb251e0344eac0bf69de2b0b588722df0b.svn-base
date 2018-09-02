//
//  JapanRegisterRequest.m
//  launcher
//
//  Created by williamzhang on 16/4/8.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "JapanRegisterRequest.h"
#import "NSDictionary+SafeManager.h"

@interface JapanRegisterRequest ()

@property (nonatomic, readonly) NSString *companyCode;
@property (nonatomic, readonly) NSString *companyName;

@end

@implementation JapanRegisterRequest

- (NSString *)api { return @"/Base-Module/CompanyUserRegister"; }
- (NSString *)type { return @"PUT"; }

- (void)registerCompanyCode:(NSString *)companyCode
                companyName:(NSString *)companyName
                    account:(NSString *)account
                   password:(NSString *)password
                   userName:(NSString *)userName
{
    self.params[@"R_C_CODE"] = companyCode;
    self.params[@"R_C_NAME"] = companyName;
    self.params[@"U_MAIL"] = account;
    self.params[@"U_TRUE_NAME"] = userName;
    self.params[@"U_PASSWOED"] = password;
    
    _companyCode = companyCode;
    _companyName = companyName;
    
    [self requestData];
}

- (BaseResponse *)prepareResponse:(id)data {
    JapanRegisterResponse *response = [JapanRegisterResponse new];
    
    response.companyShowId = [data valueStringForKey:@"C_SHOW_ID"];
    response.companyCode = self.companyCode;
    response.companyName = self.companyName;
    
    response.userShowId = [data valueStringForKey:@"SHOW_ID"];
    response.userTrueName = [data valueStringForKey:@"U_TRUE_NAME"];
    response.token = [data valueStringForKey:@"LAST_LOGIN_TOKEN"];
    
    return response;
}

@end

@implementation JapanRegisterResponse
@end