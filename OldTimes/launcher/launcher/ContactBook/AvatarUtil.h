//
//  AvatarUtil.h
//  launcher
//
//  Created by williamzhang on 15/10/10.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  头像管理，获取头像路径

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, avatarType) {
    /** 标准80 */
    avatarType_default,
    avatarType_30,
    avatarType_40,
    avatarType_60,
    avatarType_80,
    avatarType_150
};

/**
 *  获取头像路径URL
 *
 *  @param widthHeight 头像边长
 *  @param userShowId  头像用户showId (可nil，不填获取本人)
 *
 *  @return 头像路径URL
 */
FOUNDATION_EXPORT NSURL *avatarURL(avatarType type, NSString *userShowId);

/**
 *  获取头像路径URL
 *
 *  @param widthHeight     头像边长
 *  @param fullPathSuffix  头像拼接路径后缀
 *
 *  @return 头像路径URL fullPathSuffix = nil ,return nil
 */
FOUNDATION_EXPORT NSURL *avatarIMURL(avatarType type, NSString *fullPathSuffix);

/**
 *  清除成员头像缓存
 *
 *  @param userShowId 成员showId
 */
FOUNDATION_EXPORT void avatarRemoveCache(NSString *userShowId);
