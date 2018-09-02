//
//  CompanyListRequest.m
//  launcher
//
//  Created by williamzhang on 15/11/5.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "CompanyListRequest.h"
#import "NSDictionary+SafeManager.h"
#import "CompanyModel.h"

static NSString * const d_loginName = @"userLoginName";
static NSString * const d_password  = @"userPassword";

static NSString * const r_companyList = @"companyList";

@implementation CompanyListResponse
@end

@implementation CompanyListRequest

- (void)getCompanyListWithLoginName:(NSString *)loginName password:(NSString *)password {
    self.params[d_loginName] = loginName;
    self.params[d_password] = password;
    [self requestData];
}

- (NSString *)api { return @"/Base-Module/CompanyUserLogin/CompanyUserValidate";}

- (BaseResponse *)prepareResponse:(id)data {
    CompanyListResponse *response = [CompanyListResponse new];
    
    NSArray *arrayCompany = [data valueArrayForKey:r_companyList];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *companyDict in arrayCompany) {
        if (!companyDict) {
            continue;
        }
        
        CompanyModel *model = [[CompanyModel alloc] initWithDict:companyDict];
        [array addObject:model];
    }
    
    response.companyList = array;
    return response;
}

@end
