//
//  HMDeleteCommonLangageRequest.m
//  HMDoctor
//
//  Created by jasonwang on 16/9/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMDeleteCommonLangageRequest.h"

@implementation HMDeleteCommonLangageRequest
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUser2ServiceUrl:@"deleteUserCommonLanguage"];
    return postUrl;
}

@end
