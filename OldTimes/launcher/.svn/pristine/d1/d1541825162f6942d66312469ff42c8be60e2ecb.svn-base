//
//  FriendsTransferRelation.m
//  MintcodeIM
//
//  Created by kylehe on 16/5/31.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "FriendsTransferRelationRequest.h"

static NSString *const relation_Name = @"relationName";
static NSString *const relation_GroupID = @"relationGroupId";
static NSString *const user_Name = @"userName";

@implementation FriendsTransferRelationRequest

- (NSString *)action{
    return @"/transferRelation";
}

+ (void)transferRelationWithRelationName:(NSString *)relationName
                         relationGroupID:(NSNumber *)relationGroupId
                              completion:(void(^)(BOOL isSuccess))completion
{
    FriendsTransferRelationRequest *request = [[FriendsTransferRelationRequest alloc] init];
    [request.params setValue:relationName forKey:relation_Name];
    [request.params setValue:relationGroupId forKey:relation_GroupID];
    
    [request requestDataCompletion:^(IMBaseResponse *response, BOOL success) {
        completion(success);
    } isFromeCache:NO];
}

@end
