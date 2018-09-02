//
//  modifyRelationGroupRequest.m
//  MintcodeIM
//
//  Created by kylehe on 16/5/13.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "modifyRelationGroupRequest.h"
static NSString *const relationGroupName = @"relationGroupName";
static NSString *const relationGroupId   = @"relationGroupId";
@implementation modifyRelationGroupRequest

- (NSString *)action {return @"/modifyRelationGroup";}

+ (void)modifyRelationGroupWithGroupId:(long) groupId relationName:(NSString *)name completion:(void(^)(BOOL isSuccess))completion
{
    modifyRelationGroupRequest *request = [[modifyRelationGroupRequest alloc] init];
    [request.params setValue:@(groupId) forKey:relationGroupId];
    [request.params setValue:name forKey:relationGroupName];
    [request requestDataCompletion:^(IMBaseResponse *response, BOOL success) {
        if (completion)
        {
            completion(success);
        }
    }];
}

@end
