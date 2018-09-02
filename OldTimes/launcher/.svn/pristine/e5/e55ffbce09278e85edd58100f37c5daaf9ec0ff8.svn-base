//
//  ATGetClockListRequest.m
//  Clock
//
//  Created by SimonMiao on 16/7/20.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATGetClockListRequest.h"
#import "ATPunchCardModel.h"

#import <MJExtension/MJExtension.h>

@implementation ATGetClockListResponse

@end

@implementation ATGetClockListRequest

- (void)prepareRequest
{
    [super prepareRequest];
    self.api = @"/sign/List";
    
    if (self.userId.length && self.orgId.length) {
        self.params[@"userId"] = self.userId;
        self.params[@"orgId"] = self.orgId;
    }
    
    self.params[@"startTime"] = self.startTime;
    self.params[@"endTime"] = self.endTime;
    self.params[@"signType"] = self.signType;
}

- (ATHttpBaseResponse *)prepareResponse:(id)data
{
    ATGetClockListResponse *rsp = [[ATGetClockListResponse alloc] init];
    
    rsp.dataSource = [ATPunchCardModel mj_objectArrayWithKeyValuesArray:data];
    
    return rsp;
}

@end
