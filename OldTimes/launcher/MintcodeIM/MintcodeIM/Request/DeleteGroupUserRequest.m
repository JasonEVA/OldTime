//
//  DeleteGroupUserRequest.m
//  launcher
//
//  Created by Andrew Shen on 15/9/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "DeleteGroupUserRequest.h"
#import "MsgDefine.h"

static NSString * const d_sessionName = @"sessionName";
static NSString * const d_toUserName = @"toUserName";

@implementation DeleteGroupUserRequest

- (NSString *)action {
    return @"/deletegroupuser";
}

+ (void)deleteGroupSessionName:(NSString *)sessionName memeberId:(NSString *)memeberId completion:(IMBaseResponseCompletion)completion {
    DeleteGroupUserRequest *request = [[DeleteGroupUserRequest alloc] init];
    
    request.params[d_sessionName] = sessionName;
    request.params[d_toUserName] = memeberId;
    [request requestDataCompletion:completion];
}

@end