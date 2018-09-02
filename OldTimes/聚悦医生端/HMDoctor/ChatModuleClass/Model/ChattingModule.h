//
//  ChattingModule.h
//  launcher
//
//  Created by williamzhang on 15/12/31.
//  Copyright © 2015年 William Zhang. All rights reserved.
//  聊天消息管理组建

#import <Foundation/Foundation.h>
#import <MintcodeIMKit/MintcodeIMKit.h>

extern NSInteger wz_page_item_count;
extern NSInteger wz_default_needVoice_msgId;

@class MessageBaseModel;

typedef void(^WZChatLoadHistoryCompletion)(NSUInteger addCount);
/**
 *
 *  @param getLatest    获取最新消息
 *  @param success      网络请求成功
 *  @param insertCount  最新条数第一条在已加载数据的第几条 (getLatest && success时有效)（不在其中返回-1）
 */
typedef void(^WZChatReloadIfNeedCompletion)(BOOL getLatest, BOOL success, NSInteger insertCount);
typedef void(^WZChatReceiveCompletion)();
typedef void(^WZChatRefreshArrModelCompletion)(NSMutableArray *arrIndexpaths);
typedef void(^WZChatPlayVoiceCompletion)(long long playVoiceMsgId, NSString *voicePath);

@interface ChattingModule : NSObject

@property (nonatomic, strong) ContactDetailModel *sessionModel;
@property (nonatomic, strong) NSMutableArray *showingMessages;

@property (nonatomic, readonly)  UserProfileModel  *targetProfile; // 聊天会话详情

@property (nonatomic, assign) long long currentNeedPlayVoiceMsgId;

/// 要使用该方法请在loadHistoryCompletion:前调用
- (void)willLoadLatestHistory:(void (^)())completion;
/// 获取网络最新消息
- (void)loadHistoryCompletion:(WZChatReloadIfNeedCompletion)completion;
/// 获取历史消息
- (void)loadMoreHistoryCompletion:(WZChatLoadHistoryCompletion)completion;
/// 获取本地最新消息
- (void)loadLocalMessagesCompletion:(void (^)())completion;

// 消息撤回刷新
- (void)refreshReSendMessage:(WZChatRefreshArrModelCompletion)completion;
- (void)receiveMessage:(WZChatReceiveCompletion)completion;
- (void)sendMessage:(void (^)())completion;
- (void)playVoice:(WZChatPlayVoiceCompletion)completion;
/// 只用于需要刷新界面数据，不做其他操作（仅用于[tableView reloadData]）
- (void)reloadMessages:(void(^)())completion;

- (void)handleErrorMessage:(void(^)(NSString *))errorBlock;

- (void)setReadMessages;

/// 是否持有messageManager delegate
@property (nonatomic, readonly) BOOL isAlive;
/// 启动，夺回messageManager delegate
- (void)alive:(BOOL)alive;

/**
 *  配置会话详情
 */
- (void)configTargetProfile;

@end
