//
//  HealthEducationShareRequest.m
//  HMDoctor
//
//  Created by jasonwang on 2016/10/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HealthEducationShareRequest.h"

@implementation HealthEducationShareRequest

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postNoticeServiceUrl:@"shareMcNotes"];
    return postUrl;
}

@end
