//
//  ChatMemberCache.h
//  HMDoctor
//
//  Created by Andrew Shen on 2017/3/28.
//  Copyright © 2017年 yinquan. All rights reserved.
//  聊天成员缓存

#import <Foundation/Foundation.h>

@interface ChatMemberCache : NSObject


/**
 获取聊天用户nickName

 @param uid uid
 @return 用户聊天用户nickName
 */
FOUNDATION_EXPORT NSString *chatMember(NSString *uid);


/**
 缓存用户聊天名

 @param uid uid
 @param nickName 聊天名
 */
FOUNDATION_EXPORT void cacheChatMember(NSString *uid, NSString *nickName);


/**
 移除用户聊天名缓存
 
 @param uid uid
 */
FOUNDATION_EXPORT void removeChatMember(NSString *uid);
@end
