//
//  ChatMsgManager.h
//  Titans
//
//  Created by Remon Lv on 14-9-10.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//  聊天消息管理器，为了分担MessageManager的逻辑复杂度

#import <Foundation/Foundation.h>
#import "MessageBaseModel+Private.h"
#import "ContactDetailModel.h"
#import "AudioMessageManager.h"

@protocol ChatMsgManagerDelegate <NSObject>

@optional
/** 发送消息的委托(专为socket连接等时间服务)
 */
- (void)ChatMsgManagerDelegateCallBack_sendMessageForConnection:(NSString *)message;

/** 发送文本的委托
 */
- (void)ChatMsgManagerDelegateCallBack_sendMessage:(NSString *)message ContactModel:(ContactDetailModel *)contactModel BaseModel:(MessageBaseModel *)baseModel;

/**
 *  发送信息修改消息
 */
- (void)ChatMsgManagerDelegateCallBack_sendUserModified:(NSString *)message;

/** 重新发送文字、语音消息的委托
 */
- (void)ChatMsgManagerDelegateCallBack_reSendMessageWithBaseModel:(MessageBaseModel *)baseModel isSuccess:(BOOL)success Result:(NSInteger)result;

/** 收到数据类消息的委托
 */
- (void)ChatMsgManagerDelegateCallBack_receiveMessageWithMessageModel:(MessageBaseModel *)msgModel;


/** 收到数据更新的委托
 */
- (void)ChatMsgManagerDelegateCallBack_receiveUpdateMessageWithMessageModel:(MessageBaseModel *)baseModel;

/** 收到自己的同步消息
 */
- (void)ChatMsgManagerDelegateCallBack_receiveMessageSynch:(MessageBaseModel *)baseModel;

/** 收到发送消息成功的委托
 */
- (void)ChatMsgManagerDelegateCallBack_receiveFinishSendWithBaseModel:(MessageBaseModel *)baseModel;

/** ws登录成功消息委托
 */
- (void)ChatMsgManagerDelegateCallBack_wsLoginIn;

/** ws登录失败消息委托
 */
- (void)ChatMsgManagerDelegateCallBack_wsLoginOutWithContent:(NSString *)content;

/** 收到心跳回执的委托
 */
- (void)ChatMsgManagerDelegateCallBack_receiveLoginKeepSuccess;

/** 收到已读消息委托
 */
- (void)ChatMsgManagerDelegateCallBack_receiveReadedMessages:(MessageBaseModel *)baseModel;

/** 收到标记重点的委托
 */
- (void)ChatMsgManagerDelegateCallBack_receiveMarkedMessages:(MessageBaseModel *)baseModel important:(BOOL)isImportant;

/**
 *  收到清空指令的委托
 *
 */
- (void)ChatMsgManagerDelegateCallBack_receiveClearMessages:(MessageBaseModel *)baseModel;

/** 收到打开会话委托
 */
- (void)ChatMsgManagerDelegateCallBack_receiveOpenMessages:(MessageBaseModel *)baseModel;

/// 收到移除会话委托
- (void)ChatMsgManagerDelegateCallBack_receiveRemoveMessage:(MessageBaseModel *)baseModel;

/** 收到撤回消息委托
 */
- (void)ChatMsgManagerDelegateCallBack_receiveReSendMessage:(MessageBaseModel *)baseModel;
/// 好友同步指令
- (void)ChatMsgManagerDelegateCallBack_receiveRelationMessage:(MessageBaseModel *)message;

/// 发送附件消息完成下锚点打包的委托
- (void)ChatMsgManagerDelegateCallBack_anchorAttachMessageWithContactModel:(ContactDetailModel *)contactModel baseModel:(MessageBaseModel *)baseModel;

/// 发送附件消息完成起锚点打包的委托
- (void)ChatMsgManagerDelegateCallBack_unmoorAttachMessageWithBaseModel:(MessageBaseModel *)baseModel socketMessage:(NSString *)socketMessage;

@end

@interface ChatMsgManager : NSObject

@property (nonatomic,weak) id <ChatMsgManagerDelegate> delegate;

/** 单例
 */
+ (ChatMsgManager *)share;

/** 处理收到的消息
 */
- (void)parseReceiveMessage:(id)message;

/** 批量处理收到的消息
 */
- (void)parseOffLineMessages:(NSArray *)messages;

/** 登录WebSocket
 */
- (void)login;

/** 心跳包
 */
- (void)loginKeep;

/** 发送消息（文本、语音）at功能
 */
- (void)sendMessageTo:(NSString *)toLoginName NickName:(NSString *)nickName WithContent:(NSString *)content Type:(Msg_type)msgType atUserList:(NSArray *)atUserList;

/// 发送附件消息
- (MessageBaseModel *)anchorAttachMessageType:(Msg_type)type
                                     toTarget:(NSString *)toTarget
                                     nickName:(NSString *)nickName
                                  primaryPath:(NSString *)primaryPath
                                    minorPath:(NSString *)minorPath;
/**
 *  发送附件消息起锚
 *
 *  @param baseModel 下锚时获取的baseModel
 *  @param content   JSON格式数据 不同附件略有不同，详见AttachmentUploadModel提供的socket格式
 */
- (void)unmoorAttachMessageModel:(MessageBaseModel *)baseModel content:(NSString *)content;

/**
 *  发送用户信息更改消息
 *
 *  @return 用户消息更改后的modified
 */
- (void)sendUserModified:(long long)modified;

@end
