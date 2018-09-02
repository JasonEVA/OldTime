//
//  HMNewCareReadedRequest.m
//  HMClient
//
//  Created by jasonwang on 2017/6/19.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "HMNewCareReadedRequest.h"

@implementation HMNewCareReadedRequest

- (NSString*)postUrl
{
    NSString* postUrl = [ClientHelper postUser2ServiceUrl:@"batchMarkCareReaded"];
    return postUrl;
}

@end
