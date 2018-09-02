//
//  MessageOfflineDAL.m
//  Titans
//
//  Created by Remon Lv on 14-9-1.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "MessageOfflineDAL.h"
#import <MJExtension/MJExtension.h>
#import "MsgUserInfoMgr.h"
#import "MsgDefine.h"

@implementation MessageOfflineDAL

- (void)getOfflineMessage
{
    // 复用需要清理
    [self._arrMsg removeAllObjects];
    
    // 给服务器的数据(账密需要加密)
    self._dictInput[M_I_appName] = [[MsgUserInfoMgr share] getAppName];
    self._dictInput[M_I_userName] = [[MsgUserInfoMgr share] getUid];
    self._dictInput[M_I_userToken] = [[MsgUserInfoMgr share] getToken];
    self._dictInput[M_I_msgId] = [[MsgUserInfoMgr share] getMaxMsgId];
    
    NSURL *url = [NSURL URLWithString:[[[MsgUserInfoMgr share] getHttpIp] stringByAppendingPathComponent:@"/api/offlinemsg"]];
    self._download = [[SGdownloader alloc] initWithURL:url timeout:10 dict:self._dictInput];
    [self._download startWithDelegate:self];
    PRINT_JSON_INPUT(self._dictInput, url);
}

#pragma mark -- SGDownloader Delegate
- (void)SGDownloadFinished:(NSData *)fileData
{
    NSDictionary *dictTmp = [fileData mj_keyValues];
    self._dictOutput = [NSMutableDictionary dictionaryWithDictionary:dictTmp];
    PRINT_JSON_OUTPUT(self._dictOutput);
    
    if ([self isSuccessCode])
    {
        // 数据组
        id obj = self._dictOutput[M_I_msg];
        if (CHECK_TEMP_OBJECT_IF_NOT_NULL(obj))
        {
            for (NSDictionary *dict in (NSArray *)obj)
            {
                if (dict)
                {
                    MessageBaseModel *msgModel = [[MessageBaseModel alloc] initWithDict:dict];
                    [self._arrMsg addObject:msgModel];
                }
            }
        }
    
        // msgId
        obj = self._dictOutput[M_I_msgId];
        if (CHECK_TEMP_OBJECT_IF_NOT_NULL(obj))
        {
            if ((NSNumber *)obj)
            {
                [[MsgUserInfoMgr share] saveMaxMsgId:[(NSNumber *)obj longLongValue]];
            }
        }
        
        // msgId
        obj = self._dictOutput[M_I_remain];
        if (CHECK_TEMP_OBJECT_IF_NOT_NULL(obj))
        {
            if ((NSString *)obj)
            {
                self._remain = [(NSString *)obj integerValue];
            }
        }
        
        // 发送委托
        if ([self.delegateMsgOffline respondsToSelector:@selector(MessageOfflineDALDelegateCallBack_FinishWith:)])
        {
            [self.delegateMsgOffline MessageOfflineDALDelegateCallBack_FinishWith:self];
        }
        return;
    }
    else
    {
        NSInteger obj = [self._dictOutput[M_I_code] integerValue];
        // IMToken失效
        if (obj == 4000)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:MTWebsocketLogoutNotification object:nil];
            
            return;
        }
    }
    
    // 其它原因
    if ([self.delegateMsgOffline respondsToSelector:@selector(MessageOfflineDALDelegateCallBack_FailWith:)])
    {
        [self.delegateMsgOffline MessageOfflineDALDelegateCallBack_FailWith:self];
        return;
    }
 
}

- (void)SGDownloadFail:(NSError *)error
{
    // 其它原因
    if ([self.delegateMsgOffline respondsToSelector:@selector(MessageOfflineDALDelegateCallBack_FailWith:)])
    {
        [self.delegateMsgOffline MessageOfflineDALDelegateCallBack_FailWith:self];
        return;
    }
}

@end
