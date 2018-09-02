//
//  LogUploadRequest.m
//  HMDoctor
//
//  Created by Andrew Shen on 2017/2/22.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "LogUploadRequest.h"

@implementation LogUploadRequest

- (NSString *)action {
    UserInfoHelper* helper = [UserInfoHelper defaultHelper];
    UserInfo* user = [helper currentUserInfo];
    if (!user) {
        return @"";
    }
    return [NSString stringWithFormat:@"/uniqueComservice2/base.do?method=uploadAppLog&userId=%ld",user.userId];
}
- (void)prepareRequest {
    [super prepareRequest];
    
}

@end
