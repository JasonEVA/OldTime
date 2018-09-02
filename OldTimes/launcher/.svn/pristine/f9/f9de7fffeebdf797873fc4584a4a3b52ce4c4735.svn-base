//
//  UpdateGroupNameRequest.m
//  launcher
//
//  Created by Andrew Shen on 15/9/22.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "UpdateGroupNameRequest.h"
#import "MsgDefine.h"

static NSString * const sessionName = @"sessionName";
static NSString * const groupName = @"groupName";

@implementation UpdateGroupNameRequest

- (NSString *)action {
   return @"/updategroupname";
}

+ (void)updateGroupUid:(NSString *)groupUid name:(NSString *)name completion:(IMBaseResponseCompletion)completion {
    UpdateGroupNameRequest *request = [[UpdateGroupNameRequest alloc] init];
    
    request.params[sessionName] = groupUid;
    request.params[groupName] = name;
    
    [request requestDataCompletion:completion];
}

@end