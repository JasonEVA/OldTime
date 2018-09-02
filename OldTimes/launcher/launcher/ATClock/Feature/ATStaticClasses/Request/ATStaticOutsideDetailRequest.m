//
//  ATStaticOutsideDetailRequest.m
//  Clock
//
//  Created by Dariel on 16/7/27.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATStaticOutsideDetailRequest.h"
#import <MJExtension/MJExtension.h>
#import "ATStaticOutsideModel.h"

@implementation ATStaticOutsideDetailResponse


@end

@implementation ATStaticOutsideDetailRequest


- (void)prepareRequest
{
    [super prepareRequest];
    self.api = @"/sign/List";
    
    if (self.startTime && self.userId && self.endTime ) {
        self.params[@"userId"] = self.userId;
        self.params[@"startTime"] = self.startTime;
        self.params[@"endTime"] = self.endTime;
        self.params[@"orgId"] = self.orgId;
        self.params[@"signType"] = @3; // 考勤类型,不传返回全部,【0-未标记;1-上班;2-下班;3-外勤】
    }
    
}

- (ATHttpBaseResponse *)prepareResponse:(id)data {
    ATStaticOutsideDetailResponse *rsp = [ATStaticOutsideDetailResponse new];
    
//    NSLog(@"%@", data);
    rsp.dataSource = [ATStaticOutsideModel mj_objectArrayWithKeyValuesArray:data];
    return rsp;
}

@end
