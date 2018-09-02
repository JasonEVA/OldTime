//
//  FriendsTransferRelation.h
//  MintcodeIM
//
//  Created by kylehe on 16/5/31.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  好友移动分组

#import "IMBaseBlockRequest.h"

@interface FriendsTransferRelationRequest : IMBaseBlockRequest

/**
 *
 *
 *  @param relationName    好友用户名
 *  @param relationGroupId 好友分组ID
 *  @param userName        但前用户的用户名
 *  @param completion      完成后的回调
 */
+ (void)transferRelationWithRelationName:(NSString *)relationName
                         relationGroupID:(NSNumber *)relationGroupId
                              completion:(void(^)(BOOL isSuccess))completion;

@end
