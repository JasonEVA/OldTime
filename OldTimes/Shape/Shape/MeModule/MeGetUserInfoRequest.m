//
//  MeGetUserInfoRequest.m
//  Shape
//
//  Created by jasonwang on 15/10/23.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MeGetUserInfoRequest.h"
#import "UrlInterfaceDefine.h"
#import <MJExtension/MJExtension.h>

@implementation MeGetUserInfoRequest

- (void)prepareRequest
{
    self.action = @"authapi/getUserInfo";
    [super prepareRequest];
}

- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    MeGetUserInfoResponse *response = [[MeGetUserInfoResponse alloc]init];
    response.message = [super prepareResponse:data].message;
    if ([data objectForKey:VAR_DATA] != [NSNull null] && [data objectForKey:VAR_DATA] != nil) {
        NSDictionary *dict = [data objectForKey:VAR_DATA];
        MeGetUserInfoModel *model = [MeGetUserInfoModel objectWithKeyValues:dict];
        response.userInfoMogdel = model;
        
    }
    
    return response;
}

@end

@implementation MeGetUserInfoResponse


@end