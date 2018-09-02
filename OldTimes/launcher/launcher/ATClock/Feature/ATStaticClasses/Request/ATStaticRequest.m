//
//  ATStaticRequest.m
//  Clock
//
//  Created by Dariel on 16/7/20.
//  Copyright © 2016年 Dariel. All rights reserved.
//

#import "ATStaticRequest.h"
#import <MJExtension/MJExtension.h>
#import "ATStaticContentModel.h"

@implementation ATStaticResponse


@end


@implementation ATStaticRequest


- (void)prepareRequest
{
    [super prepareRequest];
    self.api = @"/sign/Statistics";
    
    if (self.startTime && self.userId && self.endTime ) {
        self.params[@"userId"] = self.userId;
        self.params[@"startTime"] = self.startTime;
        self.params[@"endTime"] = self.endTime;
        self.params[@"orgId"] = self.orgId;
    }
}

- (ATHttpBaseResponse *)prepareResponse:(id)data {
    ATStaticResponse *rsp = [ATStaticResponse new];
    
//    NSLog(@"%@", data);
    
    rsp.dataSource = [ATStaticContentModel mj_objectWithKeyValues:data];
    return rsp;
}


@end
