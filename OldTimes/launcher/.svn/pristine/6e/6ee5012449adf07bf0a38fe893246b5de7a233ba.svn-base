//
//  ContactBookGetCompanyDeptUpDateTimeRequest.m
//  launcher
//
//  Created by TabLiu on 16/3/17.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ContactBookGetCompanyDeptUpDateTimeRequest.h"

static NSString * const parentId = @"parentId";
static NSString * const isChildDept = @"isChildDept"; //isChildDept 0=当下部门，1=包含自部门

@implementation ContactBookGetCompanyDeptUpDateTimeRequest

- (NSString *)api {
    return @"/Base-Module/CompanyDept/GetLastUpdateTime";
}
- (NSString *)type {
    return @"GET";
}

- (void)requestData
{
    [self.params setValue:self.parentId forKey:parentId];
    [self.params setValue:@0 forKey:isChildDept];
    
    [super requestData];
}


- (BaseResponse *)prepareResponse:(id)data {
    ContactBookGetCompanyDeptUpDateTimeResponse *response =[ContactBookGetCompanyDeptUpDateTimeResponse new];
    response.dict = data;
    response.parentId = self.parentId;
    return response;
}


@end


@implementation ContactBookGetCompanyDeptUpDateTimeResponse

@end