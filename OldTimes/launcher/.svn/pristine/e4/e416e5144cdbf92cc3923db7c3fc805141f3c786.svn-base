//
//  ApplyForwardingRequest.m
//  launcher
//
//  Created by Conan Ma on 15/9/10.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyForwardingRequest.h"

static NSString *const SHOW_ID = @"SHOW_ID";
static NSString *const A_APPROVE = @"A_APPROVE";
static NSString *const A_APPROVE_NAME = @"A_APPROVE_NAME";
static NSString *const A_REASON = @"A_REASON";


@implementation ApplyForwardingResponse
- (NSMutableDictionary *)dict
{
    if (!_dict)
    {
        _dict = [[NSMutableDictionary alloc] init];
    }
    return _dict;
}
@end

@implementation ApplyForwardingRequest
- (void)GetShowID:(NSString *)ShowID WithApprove:(NSString *)Approve WithApproveName:(NSString *)ApproveName WithReason:(NSString *)Reason
{
    self.params[SHOW_ID] = ShowID;
    self.params[A_APPROVE] = Approve;
    self.params[A_APPROVE_NAME] = ApproveName;
    self.params[A_REASON] = Reason;
    [self requestData];
}

- (NSString *)api
{
    return @"/Approve-Module/Approve/ApproveTransmit";
}

- (NSString *)type
{
    return @"POST";
}

- (BaseResponse *)prepareResponse:(id)data
{
    ApplyForwardingResponse *response = [[ApplyForwardingResponse alloc] init];
    response.dict = (NSMutableDictionary *)data;
    return response;
}
@end
