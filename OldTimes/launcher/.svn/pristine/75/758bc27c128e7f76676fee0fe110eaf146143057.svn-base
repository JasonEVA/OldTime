//
//  ApplyGetApplyDetailRequest.m
//  launcher
//
//  Created by Conan Ma on 15/9/8.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyGetApplyDetailRequest.h"
#import "ApplyDetailInformationModel.h"

@implementation ApplyGetApplyDetailResponse
@end

static NSString *const apply_SHOW_ID  = @"SHOW_ID";

@implementation ApplyGetApplyDetailRequest
- (void)GetShowID:(NSString *)ShowID
{
    self.params[apply_SHOW_ID] = ShowID;
    [self requestData];
}

- (NSString *)api
{
    return @"/Approve-Module/Approve";
}

- (NSString *)type
{
    return @"GET";
}

- (BaseResponse *)prepareResponse:(id)data
{
    ApplyGetApplyDetailResponse *response = [ApplyGetApplyDetailResponse new];

    response.model = [[ApplyDetailInformationModel alloc] initWithDictEdit:data];
    
    return response;
}
@end
