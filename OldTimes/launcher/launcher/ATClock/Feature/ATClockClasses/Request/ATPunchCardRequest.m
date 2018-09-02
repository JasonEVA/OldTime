//
//  ATPunchCardRequest.m
//  Clock
//
//  Created by SimonMiao on 16/7/19.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import "ATPunchCardRequest.h"
#import "ATPunchCardModel.h"

#import <MJExtension/MJExtension.h>

@implementation ATPunchCardResponse

@end

@implementation ATPunchCardRequest

- (void)prepareRequest
{
    [super prepareRequest];
    self.api = @"/sign/AddOrUpdate";
    if (self.orgId && self.userId && self.lon && self.lat && self.location) {
        self.params[@"orgId"] = self.orgId;
        self.params[@"userId"] = self.userId;
        self.params[@"lon"] = self.lon;
        self.params[@"lat"] = self.lat;
        self.params[@"location"] = self.location;
    }
    self.params[@"remark"] = self.remark;
    self.params[@"networkType"] = self.networkType;

    if (self.signId) {
        self.params[@"signId"] = self.signId;
    }
    self.params[@"signType"] = self.signType;
}

- (ATHttpBaseResponse *)prepareResponse:(id)data {
    ATPunchCardResponse *rsp = [ATPunchCardResponse new];
    
    ATPunchCardModel *model = [ATPunchCardModel mj_objectWithKeyValues:data];
    rsp.punchModel = model;
    
    return rsp;
}

@end
