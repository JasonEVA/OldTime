//
//  CreateNewCompanyRequest.m
//  launcher
//
//  Created by williamzhang on 16/4/12.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "CreateNewCompanyRequest.h"
#import "UnifiedUserInfoManager.h"
#import "NSDictionary+SafeManager.h"

@interface CreateNewCompanyRequest ()

@property (nonatomic, readonly) NSString *companyCode;
@property (nonatomic, readonly) NSString *companyName;

@end

@implementation CreateNewCompanyRequest

- (NSString *)api  { return @"/Base-Module/CompanyUserRegister/PutCompanyUserRegister"; }
- (NSString *)type { return @"PUT"; }

- (void)requestCompanyName:(NSString *)companyName companyCode:(NSString *)companyCode userName:(NSString *)userName {
    self.params[@"R_C_CODE"]     = companyCode;
    self.params[@"R_C_NAME"]     = companyName;
    self.params[@"U_MAIL"]     = [[UnifiedUserInfoManager share] getAccountWithEncrypt:NO];
    self.params[@"U_TRUE_NAME"] = userName;
    
    _companyCode = companyCode;
    _companyName = companyName;
    
    [self requestData];
}

- (BaseResponse *)prepareResponse:(id)data {
    CreateNewCompanyResponse *response = [CreateNewCompanyResponse new];
    
    response.companyShowId = [data valueStringForKey:@"C_SHOW_ID"];
    response.companyCode   = self.companyCode;
    response.companyName   = self.companyName;
    
    response.userShowId   = [data valueStringForKey:@"SHOW_ID"];
    response.userTrueName = [data valueStringForKey:@"U_TRUE_NAME"];
    response.token        = [data valueStringForKey:@"LAST_LOGIN_TOKEN"];
    
    return response;
}

@end

@implementation CreateNewCompanyResponse
@end