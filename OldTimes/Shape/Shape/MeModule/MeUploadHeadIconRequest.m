//
//  MeUplloadHeadIconRequest.m
//  Shape
//
//  Created by jasonwang on 15/10/26.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "MeUploadHeadIconRequest.h"
#import "UrlInterfaceDefine.h"
#import <MJExtension/MJExtension.h>

@implementation MeUploadHeadIconRequest
- (void)prepareRequest
{
    self.action = @"authapi/UploadHeadIcon";
    [super prepareRequest];
}

- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    MeUploadHeadIconResponse *response = [[MeUploadHeadIconResponse alloc]init];
    
    response.message = [super prepareResponse:data].message;
    
    if ([data objectForKey:VAR_DATA] != [NSNull null] && [data objectForKey:VAR_DATA] != nil) {
        NSDictionary *dict = [data objectForKey:VAR_DATA];
        MeUploadIconModel *model = [MeUploadIconModel objectWithKeyValues:dict];
        response.model = model;
        
    }
    return response;

}

@end

@implementation MeUploadHeadIconResponse


@end