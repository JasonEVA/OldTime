//
//  MeRevisedCodeRequest.m
//  launcher
//
//  Created by conanma on 15/10/13.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "MeRevisedCodeRequest.h"

static NSString *const SHOWID = @"showId";
static NSString *const OLDPW = @"oldPassword";
static NSString *const NEWPW = @"newPassword";

@implementation MeRevisedCodeRequest
- (void)getShowID:(NSString *)showid oldPassword:(NSString *)oldPW newPassword:(NSString *)newPW
{
    self.params[SHOWID] = showid;
    self.params[OLDPW] = oldPW;
    self.params[NEWPW] = newPW;
    [self requestData];
}

- (NSString *)api
{
    return @"/Base-Module/CompanyUser/UpdatePassword";
}

- (NSString *)type
{
    return @"POST";
}

-(BaseResponse *)prepareResponse:(id)data
{
    MeRevisedCodeResponse *response = [[MeRevisedCodeResponse alloc] init];
    response.dict = [[NSMutableDictionary alloc] initWithDictionary:data];
    return response;
}

@end

@implementation MeRevisedCodeResponse

- (NSMutableDictionary *)dict
{
    if (!_dict)
    {
        _dict = [[NSMutableDictionary alloc] init];
    }
    return _dict;
}
@end
