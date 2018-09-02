//
//  HMTopCommonLangageRequest.m
//  HMDoctor
//
//  Created by jasonwang on 16/9/12.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMTopCommonLangageRequest.h"

@implementation HMTopCommonLangageRequest
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUser2ServiceUrl:@"stickOutUserCommonLanguage"];
    return postUrl;
}

@end
