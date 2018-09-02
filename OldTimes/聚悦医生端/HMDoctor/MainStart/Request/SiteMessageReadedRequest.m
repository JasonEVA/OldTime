//
//  SiteMessageReadedRequest.m
//  HMClient
//
//  Created by jasonwang on 16/9/9.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "SiteMessageReadedRequest.h"

@implementation SiteMessageReadedRequest

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"setMsgRead"];
    return postUrl;
}

@end
