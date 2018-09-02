//
//  MsgUserInfoMgr.h
//  PalmDoctorDR
//
//  Created by Remon Lv on 15/5/12.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//  IM配置表

#import <Foundation/Foundation.h>

@interface MsgUserInfoMgr : NSObject

/// 单例
+ (MsgUserInfoMgr *)share;

@property (nonatomic) BOOL _isLoginIn;

@property (nonatomic, setter=saveAppToken:, getter=getAppToken) NSString *appToken;
@property (nonatomic, copy) NSString *remoteNotifyToken;
@property (nonatomic, copy) NSString *voipToken;
@property (nonatomic, copy) NSString *loginType;
@property (nonatomic, copy) NSString *voipUid;

@property (nonatomic, assign) long long loadRelationGroupInfoTimeInterval;
@property (nonatomic, assign) long defaultGroupId;

/// Token（plist中）
- (NSString *)getToken;
- (void)saveToken:(NSString *)token;

/// 用户UID
- (void)saveUid:(NSString *)uid;
- (NSString *)getUid;

/// maxMsgId
- (void)saveMaxMsgId:(long long)maxMsgId;
- (NSNumber *)getMaxMsgId;

/// modified
- (void)saveModified:(long long)modified;
- (NSNumber *)getModified;

/// appName
- (void)saveAppName:(NSString *)appName;
- (NSString *)getAppName;

/// nickName
- (void)saveNickName:(NSString *)nickName;
- (NSString *)getNickName;

/// wsIp
- (void)saveWsIp:(NSString *)wsIp;
- (NSString *)getWsIp;

/// httpIp
- (void)saveHttpIp:(NSString *)httpIp;
- (NSString *)getHttpIp;

/// testIp
- (void)saveTestIp:(NSString *)testIp;
- (NSString *)getTestIp;

/// 存上一条cid 防重复
- (void)saveCid:(long long)cid;
- (long long)getCid;

/**
 *  保存加解密key
 */
- (void)saveEncyptKey:(NSString *)encryptKey;
- (NSString *)getEncryptKey;
@end
