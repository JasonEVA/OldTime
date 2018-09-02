//
//  GetLastApproveMemberRequest.m
//  launcher
//
//  Created by Dee on 16/8/5.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "GetLastApproveMemberRequest.h"

@implementation GetLastApproveMemberRequest

- (NSString *) api { return @"/Approve-Module/Approve/GetLastApproveMemberV2"; }

- (NSString *)type{ return  @"GET"; }

- (void)getLastApproveMemeberRequest
{
    [self requestData];
}

- (BaseResponse *)prepareResponse:(id)data
{
    return data;
}

@end

@implementation GetLastApproveMemberResponse

@end