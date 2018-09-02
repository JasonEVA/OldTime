//
//  MeReviseUserInformationRequest.m
//  launcher
//
//  Created by conanma on 15/10/14.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "MeReviseUserInformationRequest.h"

static NSString * const personDetail_show_id              = @"SHOW_ID";
static NSString * const personDetail_u_true_name          = @"U_TRUE_NAME";
static NSString * const personDetail_u_status             = @"U_STATUS";
static NSString * const personDetail_u_dept_id            = @"U_DEPT_ID";
static NSString * const personDetail_d_path_name          = @"D_PATH_NAME";
static NSString * const personDetail_u_mobile             = @"U_MOBILE";
static NSString * const personDetail_u_mail               = @"U_MAIL";
static NSString * const personDetail_u_job                = @"U_JOB";
static NSString * const personDetail_u_telephone          = @"U_TELEPHONE";

@implementation MeReviseUserInformationRequest
- (void)ChangePersonInfoWithDict:(NSMutableDictionary *)dict
{
    if ([dict objectForKey:personDetail_show_id])
    {
        self.params[personDetail_show_id] = [dict objectForKey:personDetail_show_id];
    }
    if ([dict objectForKey:personDetail_u_true_name])
    {
        self.params[personDetail_u_true_name] = [dict objectForKey:personDetail_u_true_name];
    }
//    if ([dict objectForKey:personDetail_u_status])
//    {
//        self.params[personDetail_u_status] = [dict objectForKey:personDetail_u_status];
//    }
//    if ([dict objectForKey:personDetail_u_dept_id])
//    {
//        self.params[personDetail_u_dept_id] = [dict objectForKey:personDetail_u_dept_id];
//    }
//    if ([dict objectForKey:personDetail_d_path_name])
//    {
//        self.params[personDetail_d_path_name] = [dict objectForKey:personDetail_d_path_name];
//    }
    if ([dict objectForKey:personDetail_u_mobile])
    {
        self.params[personDetail_u_mobile] = [dict objectForKey:personDetail_u_mobile];
    }
    if ([dict objectForKey:personDetail_u_mail])
    {
        self.params[personDetail_u_mail] = [dict objectForKey:personDetail_u_mail];
    }
//    if ([dict objectForKey:personDetail_u_job])
//    {
//        self.params[personDetail_u_job] = [dict objectForKey:personDetail_u_job];
//    }
    if ([dict objectForKey:personDetail_u_telephone])
    {
        self.params[personDetail_u_telephone] = [dict objectForKey:personDetail_u_telephone];
    }
    
    [self requestData];
}

- (NSString *)api
{
//    return @"/Base-Module/CompanyUser";
    return @"/Base-Module/CompanyUser/PostUserInfo";
}

- (NSString *)type
{
    return @"POST";
}

-(BaseResponse *)prepareResponse:(id)data
{
    MeReviseUserInformationResponse *response = [[MeReviseUserInformationResponse alloc] init];
    response.dict = [[NSMutableDictionary alloc] initWithDictionary:data];
    return response;
}

@end

@implementation MeReviseUserInformationResponse

- (NSMutableDictionary *)dict
{
    if (!_dict)
    {
        _dict = [[NSMutableDictionary alloc] init];
    }
    return _dict;
}
@end
