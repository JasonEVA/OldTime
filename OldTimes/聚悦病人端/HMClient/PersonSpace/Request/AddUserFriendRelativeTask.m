//
//  AddUserFriendRelativeTask.m
//  HMClient
//
//  Created by yinqaun on 16/6/20.
//  Copyright © 2016年 YinQ. All rights reserved.
//

#import "AddUserFriendRelativeTask.h"

@implementation AddUserFriendRelativeTask


- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUser2ServiceUrl:@"addUserRelativeFriend"];
    return postUrl;
}

@end


@implementation DeleteUserFriendRelativeTask


- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUser2ServiceUrl:@"deleteRelative"];
    return postUrl;
}

@end