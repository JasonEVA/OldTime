//
//  ApplyForwardingV2Request.m
//  launcher
//
//  Created by williamzhang on 16/4/20.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ApplyForwardingV2Request.h"

@implementation ApplyForwardingV2Request

- (void)GetShowID:(NSString *)ShowID WithApprove:(NSString *)Approve WithApproveName:(NSString *)ApproveName WithReason:(NSString *)Reason {
    self.params[@"showId"]       = ShowID;
    self.params[@"aApprove"]     = Approve;
    self.params[@"aApproveName"] = ApproveName;
    self.params[@"aReason"]      = Reason;
    
    [self requestData];
}

- (NSString *)api { return @"/Approve-Module/Approve/ApproveTransmitV2"; }

- (BaseResponse *)prepareResponse:(id)data {
    ApplyForwardingV2Response *response = [ApplyForwardingV2Response new];
    response.dict = data;
    return response;
}

@end

@implementation ApplyForwardingV2Response
@end