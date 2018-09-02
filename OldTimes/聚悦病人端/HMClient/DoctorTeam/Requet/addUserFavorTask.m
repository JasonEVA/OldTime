//
//  addUserFavorTask.m
//  HMClient
//
//  Created by lkl on 16/6/7.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "addUserFavorTask.h"

@implementation addUserFavorTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserFavorService:@"addUserFavor"];
    return postUrl;
}

@end

@implementation checkUserFavorTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserFavorService:@"checkUserFavor"];
    return postUrl;
}

@end
