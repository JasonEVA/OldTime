//
//  ATGetClockRuleRequest.m
//  Clock
//
//  Created by SimonMiao on 16/7/22.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATGetClockRuleRequest.h"
#import <MJExtension/MJExtension.h>
#import "ATGetClockRuleModel.h"

#import "ATAppSync.h"

@implementation ATGetClockRuleResponse

@end

@implementation ATGetClockRuleRequest

- (void)prepareRequest
{
    [super prepareRequest];
    self.api = @"/sign/GetRule";
    if (self.orgId && self.userId) {
        self.params[@"orgId"] = self.orgId;
        self.params[@"userId"] = self.userId;
    }
    
}

- (ATHttpBaseResponse *)prepareResponse:(id)data
{
    [ATAppSync setClockRuleDict:data];
    
    ATGetClockRuleResponse *rsp = [[ATGetClockRuleResponse alloc] init];
    [ATGetClockRuleModel mj_setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"LocationList" : @"ATGetClockLocationListModel"
                 };
    }];
    rsp.ruleModel = [ATGetClockRuleModel mj_objectWithKeyValues:data];
    
    return rsp;
}

@end
