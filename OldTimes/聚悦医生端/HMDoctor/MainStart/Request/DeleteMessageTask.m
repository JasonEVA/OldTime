//
//  DeleteMessageTask.m
//  HMClient
//
//  Created by Dee on 16/6/23.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "DeleteMessageTask.h"

@implementation DeleteMessageTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"deleteMsg"];
    return postUrl;
}

- (void)makeTaskResult
{
}

@end
