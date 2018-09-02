//
//  GetSessionUserProfileDAL.h
//  MintcodeIMFramework
//
//  Created by Andrew Shen on 15/6/11.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//  获取会话中对方信息

#import "IMBaseBlockRequest.h"

@class UserProfileModel;

@interface GetSessionUserProfileDAL : IMBaseBlockRequest
/// 获取session信息
+ (void)sessionid:(NSString *)sessionId completion:(void (^)(UserProfileModel *userProfile))completion;

@end