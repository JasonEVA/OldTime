//
//  MsgUserInfoMgr.m
//  PalmDoctorDR
//
//  Created by Remon Lv on 15/5/12.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//

#import "MsgUserInfoMgr.h"
#import "IMConfigure.h"
#import "MsgDefine.h"

#define M_U_Modified                          @"mt_im_modified"
#define M_U_MaxMsgid                          @"mt_im_maxMsgId"
#define M_U_AppToken                          @"mt_im_appToken"
#define M_U_RemoteNotifyToken                 @"mt_im_remoteNotifyToken"
#define M_U_Token                             @"mt_im_token"
#define M_U_Uid                               @"mt_im_uid"
#define M_U_AppName                           @"mt_im_appName"
#define M_U_NickName                          @"mt_im_nickName"
#define M_U_WSIp                              @"mt_im_wsIp"
#define M_U_HttpIp                            @"mt_im_httpIp"
#define M_U_TestIp                            @"mt_im_testIp"
#define M_U_EncryptKey                        @"mt_im_encryptKey"
#define M_U_Cid                               @"mt_im_cid"
#define M_U_LoginType                         @"mt_im_loginType"
#define M_U_LoadRelationGroupInfoTimeInterval @"mt_im_loadRelationGroupInfoTimeInterval"
#define M_U_DefaultGroupId                    @"mt_im_defaultGroupId"
#define M_U_VoipToken                         @"mt_im_voipToken"
#define M_U_VoipUid                           @"mt_im_voipUid"

@interface MsgUserInfoMgr() {
    NSUserDefaults *_defaults;
}

@end

@implementation MsgUserInfoMgr

// 单例
+ (MsgUserInfoMgr *)share
{
    static MsgUserInfoMgr *msgUserInfoMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        msgUserInfoMgr = [[MsgUserInfoMgr alloc] init];
    });
    return msgUserInfoMgr;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _defaults = [NSUserDefaults standardUserDefaults];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(destroyMyself) name:MTWebsocketLogoutNotification object:nil];
    }
    return self;
}

- (void)destroyMyself
{
    // 清除数据
    [self removeAllData];
}


- (void)saveAppToken:(NSString *)appToken {
    [_defaults setObject:appToken forKey:M_U_AppToken];
    [_defaults synchronize];
}

- (NSString *)getAppToken {
    return [_defaults objectForKey:M_U_AppToken] ?:@"";
}

- (NSString *)remoteNotifyToken {
    return [_defaults objectForKey:M_U_RemoteNotifyToken] ?:@"";
}

- (void)setRemoteNotifyToken:(NSString *)remoteNotifyToken {
    [_defaults setObject:remoteNotifyToken forKey:M_U_RemoteNotifyToken];
    [_defaults synchronize];
}

- (NSString *)voipToken {
    return [_defaults objectForKey:M_U_VoipToken] ?: @"";
}

- (void)setVoipToken:(NSString *)voipToken {
    [_defaults setObject:voipToken forKey:M_U_VoipToken];
    [_defaults synchronize];
}

- (NSString *)voipUid {
    return [_defaults objectForKey:M_U_VoipUid] ?: @"";
}

- (void)setVoipUid:(NSString *)voipUid {
    [_defaults setObject:voipUid forKey:M_U_VoipUid];
}

- (long long)loadRelationGroupInfoTimeInterval {
    NSDictionary *dict = [_defaults objectForKey:M_U_LoadRelationGroupInfoTimeInterval];
    if (!dict) {
        return 0;
    }
    
    NSNumber *number = [dict objectForKey:[self getUid]];
    return [number longLongValue];
}

- (void)setLoadRelationGroupInfoTimeInterval:(long long)loadRelationGroupInfoTimeInterval {
    NSDictionary *dict = [_defaults objectForKey:M_U_LoadRelationGroupInfoTimeInterval];
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:dict ?: @{}];
    [newDict setObject:@(loadRelationGroupInfoTimeInterval) forKey:[self getUid]];
    [_defaults setObject:newDict forKey:M_U_LoadRelationGroupInfoTimeInterval];
}

- (long)defaultGroupId {
    NSDictionary *dict = [_defaults objectForKey:M_U_DefaultGroupId];
    if (!dict) {
        return -1;
    }
    
    NSNumber *number = [dict objectForKey:[self getUid]];
    return [number longValue];
}

- (void)setDefaultGroupId:(long)defaultGroupId {
    NSDictionary *dict = [_defaults objectForKey:M_U_DefaultGroupId];
    NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:dict ?: @{}];
    [newDict setObject:@(defaultGroupId) forKey:[self getUid]];
    [_defaults setObject:newDict forKey:M_U_DefaultGroupId];
}


- (void)saveToken:(NSString *)token {
    [_defaults setObject:token forKey:M_U_Token];
    [_defaults synchronize];
}

// Token（plist中）
- (NSString *)getToken {
    return [_defaults objectForKey:M_U_Token] ?:@"";
}

// 用户UID
- (void)saveUid:(NSString *)uid {
    [_defaults setObject:uid forKey:M_U_Uid];
    [_defaults synchronize];
}
- (NSString *)getUid {
    return [_defaults objectForKey:M_U_Uid] ?:@"";
}

// maxMsgId
- (void)saveMaxMsgId:(long long)maxMsgId
{
    
    NSDictionary *dictMsgId = [_defaults objectForKey:M_U_MaxMsgid];
    NSMutableDictionary *dictNewMsgId;
    dictNewMsgId = [NSMutableDictionary dictionaryWithDictionary:(dictMsgId ?:[NSMutableDictionary dictionary])];
    
    [dictNewMsgId setObject:[NSNumber numberWithLongLong:maxMsgId] forKey:[self getUid]];
    
    NSNumber *oldMsgId = [self getMaxMsgId];
    if ([oldMsgId longLongValue] > maxMsgId) {
        return;
    }
    
    [_defaults setObject:dictNewMsgId forKey:M_U_MaxMsgid];
    [_defaults synchronize];
}

- (NSNumber *)getMaxMsgId {
    NSDictionary *dictMsgId = [_defaults objectForKey:M_U_MaxMsgid];
    if (dictMsgId)
    {
        NSNumber *numMaxMsgId = [dictMsgId objectForKey:[self getUid]];
        if (numMaxMsgId)
        {
            return numMaxMsgId;
        }
    }
    
    return [NSNumber numberWithLongLong:0];
}

// 存cid
- (void)saveCid:(long long)cid
{
    [_defaults setObject:@(cid) forKey:M_U_Cid];
    [_defaults synchronize];
}

// modified
- (void)saveModified:(long long)modified
{
    [_defaults setObject:[NSNumber numberWithLongLong:modified] forKey:M_U_Modified];
    // 更新配置
    [_defaults synchronize];
}
- (NSNumber *)getModified
{
    NSNumber *numModified = [_defaults objectForKey:M_U_Modified];
    if (numModified)
    {
        return numModified;
    }
    return [NSNumber numberWithLongLong:0];
}

// appName
- (void)saveAppName:(NSString *)appName
{
    [_defaults setObject:appName forKey:M_U_AppName];
    // 更新配置
    [_defaults synchronize];
}
- (NSString *)getAppName
{
    NSString *appName = @"";
    if ([_defaults objectForKey:M_U_AppName]) {
        appName = [_defaults objectForKey:M_U_AppName];
    }

    return appName;
}

// nickName
- (void)saveNickName:(NSString *)nickName
{
    [_defaults setObject:nickName forKey:M_U_NickName];
    // 更新配置
    [_defaults synchronize];

}
- (NSString *)getNickName
{
    NSString *strName = @"";
    if ([_defaults objectForKey:M_U_NickName]) {
        strName = [_defaults objectForKey:M_U_NickName];
    }
    return strName;
}

// wsIp
- (void)saveWsIp:(NSString *)wsIp
{
    [_defaults setObject:wsIp forKey:M_U_WSIp];
    [_defaults synchronize];
}
- (NSString *)getWsIp
{
    NSString *wsIp = @"";
    if ([_defaults objectForKey:M_U_WSIp]) {
        wsIp = [_defaults objectForKey:M_U_WSIp];
    }
    return wsIp;
}

// httpIp
- (void)saveHttpIp:(NSString *)httpIp
{
    [_defaults setObject:httpIp forKey:M_U_HttpIp];
    [_defaults synchronize];
}
- (NSString *)getHttpIp
{
    return [_defaults objectForKey:M_U_HttpIp] ?: @"";
}

// testIp
- (void)saveTestIp:(NSString *)testIp
{
    [_defaults setObject:testIp forKey:M_U_TestIp];
    [_defaults synchronize];
}

- (NSString *)getTestIp
{
    NSString *testIp = @"";
    if ([_defaults objectForKey:M_U_TestIp]) {
        testIp = [_defaults objectForKey:M_U_TestIp];
    }
    return testIp;
}


- (void)setLoginType:(NSString *)loginType {
    [_defaults setObject:loginType forKey:M_U_LoginType];
    [_defaults synchronize];
}

- (NSString *)loginType {
    return [_defaults objectForKey:M_U_LoginType];
}

/**
 *  保存加解密key
 */
- (void)saveEncyptKey:(NSString *)encryptKey
{
    [_defaults setObject:encryptKey forKey:M_U_EncryptKey];
    [_defaults synchronize];
}

- (NSString *)getEncryptKey
{
    NSString *EncryptKey = [_defaults objectForKey:M_U_EncryptKey];
    if (EncryptKey.length > 0)
    {
        return EncryptKey;
    }
    return @"";
}



- (long long)getCid
{
    long long cid = 0;
    if ([_defaults objectForKey:M_U_Cid])
    {
        cid = [[_defaults objectForKey:M_U_Cid] longLongValue];;
    }
    
    return cid;
}





#pragma mark - RemoveData
- (void)removeAllData
{
    [_defaults removeObjectForKey:M_U_Modified];
    [_defaults removeObjectForKey:M_U_MaxMsgid];
    [_defaults removeObjectForKey:M_U_Token];
    [_defaults removeObjectForKey:M_U_Uid];
    [_defaults removeObjectForKey:M_U_NickName];
    [_defaults removeObjectForKey:M_U_EncryptKey];}
@end
