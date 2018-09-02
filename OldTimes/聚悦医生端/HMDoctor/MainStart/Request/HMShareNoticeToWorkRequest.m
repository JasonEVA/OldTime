//
//  HMShareNoticeToWorkRequest.m
//  HMDoctor
//
//  Created by jasonwang on 2017/7/20.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMShareNoticeToWorkRequest.h"

@implementation HMShareNoticeToWorkRequest
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postNoticeServiceUrl:@"shareNotice2WorkGroup"];
    return postUrl;
}

@end
