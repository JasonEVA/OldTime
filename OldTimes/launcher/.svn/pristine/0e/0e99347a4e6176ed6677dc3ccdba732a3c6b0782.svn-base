//
//  CreateGroupRequest.m
//  launcher
//
//  Created by Lars Chen on 15/9/18.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "CreateGroupRequest.h"
#import "NSDictionary+IMSafeManager.h"
#import "MsgDefine.h"

@implementation CreateGroupRequest

- (NSString *)action { return @"/creategroup"; }

+ (void)createWithUserIds:(NSArray *)userIds tag:(NSString *)tag completion:(IMBaseResponseCompletion)completion {
    CreateGroupRequest *request = [[CreateGroupRequest alloc] init];

    request.params[@"groupUsers"] = userIds;
    request.params[@"tag"] = tag;
    
    [request requestDataCompletion:completion];
}

- (IMBaseResponse *)prepareResponse:(NSDictionary *)data
{
    CreateGroupResponse *response = [CreateGroupResponse new];
    
    NSDictionary *dataDict = [data im_valueDictonaryForKey:M_I_data];
    response.groupUid = [dataDict im_valueStringForKey:@"sessionName"];
    
    return response;
}

@end

@implementation CreateGroupResponse
@end