//
//  MessageOfflineDAL.h
//  Titans
//
//  Created by Remon Lv on 14-9-1.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//  离线消息网络请求

#import <Foundation/Foundation.h>
#import "MessageBaseModel+Private.h"
#import "MsgBaseDAL.h"

@protocol MessageOfflineDALDelegate <NSObject>

// 请求得到的数据和结果码
- (void)MessageOfflineDALDelegateCallBack_FinishWith:(id)objTarget;

// 失败
- (void)MessageOfflineDALDelegateCallBack_FailWith:(id)objTarget;

@end

@interface MessageOfflineDAL : MsgBaseDAL <SGdownloaderDelegate>

@property (nonatomic,weak) id <MessageOfflineDALDelegate> delegateMsgOffline;

/**
 *  获取离线消息（分批）
 */
- (void)getOfflineMessage;

@end
