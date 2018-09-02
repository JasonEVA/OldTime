//
//  ATUpdateRemarkRequest.m
//  Clock
//
//  Created by SimonMiao on 16/7/21.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATUpdateRemarkRequest.h"
#import "ATPunchCardModel.h"
#import <MJExtension/MJExtension.h>

@implementation ATUpdateRemarkResponse

@end

@implementation ATUpdateRemarkRequest

- (void)prepareRequest {
    [super prepareRequest];
    self.api = @"/sign/UpdateRemark";
    if (self.signId && self.remark) {
        self.params[@"signId"] = self.signId;
        self.params[@"remark"] = self.remark;
    }
}

- (ATHttpBaseResponse *)prepareResponse:(id)data
{
    ATUpdateRemarkResponse *rsp = [ATUpdateRemarkResponse new];
    rsp.cardModel = [ATPunchCardModel mj_objectWithKeyValues:data];
    
    return rsp;
}


@end
