//
//  ApplyDealWiththeApplyV2Request.m
//  launcher
//
//  Created by williamzhang on 16/4/20.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ApplyDealWiththeApplyV2Request.h"

@implementation ApplyDealWiththeApplyV2Request

- (void)GetShowID:(NSString *)ShowID WithStatus:(NSString *)status WithReason:(NSString *)Reason {
    self.params[@"showId"]  = ShowID;
    self.params[@"aStatus"] = status;
    self.params[@"aReason"] = Reason;
    
    [self requestData];
}

- (NSString *)api { return @"/Approve-Module/Approve/ApproveProcessV2"; }

@end
