//
//  GetCodeRequestDAL.m
//  Shape
//
//  Created by jasonwang on 15/10/19.
//  Copyright © 2015年 Andrew Shen. All rights reserved.
//

#import "GetCodeRequestDAL.h"
#import "UrlInterfaceDefine.h"
#import <MJExtension/MJExtension.h>

#define DICT_PHONE       @"phone"

@implementation GetCodeRequestDAL

- (void)prepareRequest
{
    self.action = @"api/sendCode";
    self.params[DICT_PHONE] = self.phone;
    [super prepareRequest];
}

- (BaseResponse *)prepareResponse:(NSDictionary *)data
{
    GetCodeResponse *response = [[GetCodeResponse alloc]init];
    response.message = [super prepareResponse:data].message;

    if ([data objectForKey:VAR_DATA] != [NSNull null] && [data objectForKey:VAR_DATA] != nil) {
        NSDictionary *dict = [data objectForKey:VAR_DATA];
        response.codeToken = [dict objectForKey:VAR_CODETOKEN];

    }
    return response;
}
@end

@implementation GetCodeResponse



@end
