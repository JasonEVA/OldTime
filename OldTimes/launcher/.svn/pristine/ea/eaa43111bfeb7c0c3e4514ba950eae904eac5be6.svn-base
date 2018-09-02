//
//  createRelationGroupRequest.m
//  MintcodeIM
//
//  Created by williamzhang on 16/5/3.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "CreateRelationGroupRequest.h"

@implementation CreateRelationGroupRequest

- (NSString *)action { return @"/createRelationGroup"; }

+ (void)createGroupName:(NSString *)groupName completion:(IMBaseResponseCompletion)completion {
    CreateRelationGroupRequest *request = [[CreateRelationGroupRequest alloc] init];
    
    request.params[@"relationGroupName"] = groupName;
    [request requestDataCompletion:completion];
}

- (IMBaseResponse *)prepareResponse:(NSDictionary *)data {
    CreateRelationGroupResponse *response = [CreateRelationGroupResponse new];
    
    MessageRelationGroupModel *model = [MessageRelationGroupModel modelWithDict:data];
    model.createDate = [NSDate.date timeIntervalSince1970] * 1000;
    
    response.groupModel = model;
    return response;
}

@end

@implementation CreateRelationGroupResponse
@end