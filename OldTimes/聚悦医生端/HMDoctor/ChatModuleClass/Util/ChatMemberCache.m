//
//  ChatMemberCache.m
//  HMDoctor
//
//  Created by Andrew Shen on 2017/3/28.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "ChatMemberCache.h"




@interface ChatMemberCache ()

@property (nonatomic, strong)  NSCache  *memberCache; // <##>

@end

@implementation ChatMemberCache

+ (instancetype)share {
    static ChatMemberCache *memberManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        memberManager = [[ChatMemberCache alloc] init];
    });
    return memberManager;
}

+ (NSString *)chatMemberNickName:(NSString *)uid {
    if (!uid || uid.length == 0) {
        return nil;
    }
    NSString *nickName = [[ChatMemberCache share].memberCache objectForKey:uid];
    return nickName;
}

+ (void)cacheChatMemberName:(NSString *)nickName uid:(NSString *)uid {
    if (!nickName || !uid || uid.length == 0) {
        return;
    }
    [[ChatMemberCache share].memberCache setObject:nickName forKey:uid];
}

+ (void)removeChatMemberName:(NSString *)uid {
    if (!uid || uid.length == 0) {
        return;
    }
    [[ChatMemberCache share].memberCache removeObjectForKey:uid];
}

- (NSCache *)memberCache {
    if (!_memberCache) {
        _memberCache = [[NSCache alloc] init];
        _memberCache.name = @"com.juyuejk.memberCache";
        _memberCache.countLimit = 1000;
    }
    return _memberCache;
}

@end

/**
 获取聊天用户nickName
 
 @param uid uid
 @return 用户聊天用户nickName
 */
NSString *chatMember(NSString *uid) {
    return [ChatMemberCache chatMemberNickName:uid];
}


/**
 缓存用户聊天名
 
 @param uid uid
 @param nickName 聊天名
 */
void cacheChatMember(NSString *uid, NSString *nickName) {
    [ChatMemberCache cacheChatMemberName:nickName uid:uid];
}


/**
 移除用户聊天名缓存
 
 @param uid uid
 */
void removeChatMember(NSString *uid) {
    [ChatMemberCache removeChatMemberName:uid];
}

