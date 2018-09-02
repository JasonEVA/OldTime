//
//  ATGetCurrentServerDateRequest.m
//  Clock
//
//  Created by SimonMiao on 16/7/20.
//  Copyright © 2016年 com.mintmedical. All rights reserved.
//

#import "ATGetCurrentServerDateRequest.h"

@implementation ATGetCurrentServerDateResponse

@end

@implementation ATGetCurrentServerDateRequest

- (void)prepareRequest {
    [super prepareRequest];
    self.api = @"/sign/GetNowTime";
}

- (ATHttpBaseResponse *)prepareResponse:(id)data
{
    ATGetCurrentServerDateResponse *rsp = [[ATGetCurrentServerDateResponse alloc] init];
    if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)data;
        rsp.currentTimestamp = [dict objectForKey:@"NowTime"];
    }
    
    return rsp;
}

@end
