//
//  HMConcernSendGroupConcernRequest.m
//  HMDoctor
//
//  Created by jasonwang on 2016/12/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMConcernSendGroupConcernRequest.h"

@implementation HMConcernSendGroupConcernRequest

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUser2ServiceUrl:@"sendGroupCare"];
    return postUrl;
}

@end
