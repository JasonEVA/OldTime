//
//  MeDeleteUserAccountRequest.m
//  launcher
//
//  Created by conanma on 15/10/14.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "MeDeleteUserAccountRequest.h"
static NSString * const personDetail_show_id = @"SHOW_ID";

@implementation MeDeleteUserAccountRequest
- (void)GetShowID:(NSString *)showID
{
    self.params[personDetail_show_id] = showID;
    [self requestData];
}

- (NSString *)api
{
    return @"/Base-Module/CompanyUser";
}

- (NSString *)type
{
    return @"DELETE";
}

-(BaseResponse *)prepareResponse:(id)data
{
    MeDeleteUserAccountResponse *response = [[MeDeleteUserAccountResponse alloc] init];
    response.dict = [[NSMutableDictionary alloc] initWithDictionary:data];
    return response;
}

@end

@implementation MeDeleteUserAccountResponse
- (NSMutableDictionary *)dict
{
    if (!_dict)
    {
        _dict = [[NSMutableDictionary alloc] init];
    }
    return _dict;
}
@end