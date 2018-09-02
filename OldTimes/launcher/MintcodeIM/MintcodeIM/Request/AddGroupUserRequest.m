//
//  AddGroupUserRequest.m
//  launcher
//
//  Created by Andrew Shen on 15/9/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "AddGroupUserRequest.h"
#import "MsgDefine.h"

static NSString * const d_sessionName = @"sessionName";
static NSString * const d_groupUsers = @"groupUsers";

@implementation AddGroupUserRequest

- (NSString *)action { return @"/addgroupuser"; }

+ (void)sessionName:(NSString *)sessionName addUserIds:(NSArray *)userIds completion:(IMBaseResponseCompletion)completion {
    AddGroupUserRequest *request = [[AddGroupUserRequest alloc] init];
    request.params[d_sessionName] = sessionName;
    request.params[d_groupUsers]  = userIds;
    
    [request requestDataCompletion:completion];
}

@end
