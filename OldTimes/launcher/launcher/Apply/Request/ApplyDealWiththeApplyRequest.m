//
//  ApplyDealWiththeApplyRequest.m
//  launcher
//
//  Created by Conan Ma on 15/9/8.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyDealWiththeApplyRequest.h"


@implementation ApplyDealWiththeApplyResponse

@end

static NSString *const apply_SHOW_ID  = @"SHOW_ID";
static NSString *const apply_A_STATUS = @"A_STATUS";
static NSString *const apply_A_REASON = @"A_REASON";

@implementation ApplyDealWiththeApplyRequest


- (void)GetShowID:(NSString *)ShowID WithStatus:(NSString *)status WithReason:(NSString *)Reason
{
    self.params[apply_SHOW_ID] = ShowID;
    self.params[apply_A_STATUS] = status;
    self.params[apply_A_REASON] = Reason;
    
    [self requestData];
}

- (NSString *)api
{
    return @"/Approve-Module/Approve/ApproveProcess";
}

- (NSString *)type
{
    return @"POST";
}

- (BaseResponse *)prepareResponse:(id)data
{
    ApplyDealWiththeApplyResponse *response = [ApplyDealWiththeApplyResponse new];
    return response;
}
@end
