//
//  LoginRequestDAL.m
//  Shape
//
//  Created by jasonwang on 15/10/19.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "LoginRequestDAL.h"
#import "UrlInterfaceDefine.h"
#import <MJExtension/MJExtension.h>

#define DICT_PHONR       @"phone"
#define DICT_PASSWORD    @"password"


@implementation LoginRequestDAL

- (void)prepareRequest
{
    self.action = @"api/userLogin";
    self.params[DICT_PHONR] = self.phone;
    self.params[DICT_PASSWORD] = self.password;
    [super prepareRequest];
}
- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    LoginResponse *response = [[LoginResponse alloc]init];
    
    response.message = [super prepareResponse:data].message;

    if ([data objectForKey:VAR_DATA] != [NSNull null] && [data objectForKey:VAR_DATA] != nil) {
        NSDictionary *dict = [data objectForKey:VAR_DATA];
        LoginResultModel *model = [LoginResultModel objectWithKeyValues:dict];
        response.resultModel = model;
        
    }
    return response;
}


@end


@implementation LoginResponse



@end
