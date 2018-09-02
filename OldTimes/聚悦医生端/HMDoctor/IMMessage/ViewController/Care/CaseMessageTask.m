//
//  CaseMessageTask.m
//  HMDoctor
//
//  Created by lkl on 16/6/22.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CaseMessageTask.h"

@implementation CaseMessageTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUser2ServiceUrl:@"sendUserWordsSoundAndCare"];
    return postUrl;
}

@end


@implementation UploadFileTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUniqueComservice2Url:@"uploadFile"];
    return postUrl;
}

@end