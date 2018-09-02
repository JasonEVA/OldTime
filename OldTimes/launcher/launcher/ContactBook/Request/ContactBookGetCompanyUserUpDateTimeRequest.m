//
//  ContactBookGetCompanyUserUpDateTimeRequest.m
//  launcher
//
//  Created by TabLiu on 16/3/17.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ContactBookGetCompanyUserUpDateTimeRequest.h"

static NSString * const deptId = @"deptId";
static NSString * const isChildDept = @"isChildDept"; //isChildDept 0=当下部门，1=包含自部门

@implementation ContactBookGetCompanyUserUpDateTimeRequest

- (NSString *)api {
    return @"/Base-Module/CompanyUser/GetLastUpdateTime";
}
- (NSString *)type {
    return @"GET";
}

- (void)requestData
{
    [self.params setValue:self.deptId forKey:deptId];
    [self.params setValue:@0 forKey:isChildDept];
    
    [super requestData];
}

- (BaseResponse *)prepareResponse:(id)data {
    ContactBookGetCompanyUserUpDateTimeResponse *response = [ContactBookGetCompanyUserUpDateTimeResponse new];
    response.dict = data;
    response.deptId = self.deptId;
    return response;
}

@end


@implementation ContactBookGetCompanyUserUpDateTimeResponse

@end