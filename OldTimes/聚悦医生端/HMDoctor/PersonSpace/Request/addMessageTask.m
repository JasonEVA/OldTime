//
//  addMessageTask.m
//  HMClient
//
//  Created by lkl on 16/6/8.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "addMessageTask.h"

@implementation addMessageTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"addMsg"];
    return postUrl;
}

@end

