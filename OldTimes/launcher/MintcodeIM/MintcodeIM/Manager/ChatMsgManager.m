//
//  ChatMsgManager.m
//  Titans
//
//  Created by Remon Lv on 14-9-10.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "ChatMsgManager.h"
#import "MessageBaseModel+Extension.h"
#import <MJExtension/MJExtension.h>
#import "ASJSONKitManager.h"
#import "NSDate+IMManager.h"
#import "MsgUserInfoMgr.h"
#import "IMConfigure.h"
#import "MsgDefine.h"
#import "MsgSqlMgr.h"

#define DICT_MSGID          @"msgId"
#define DICT_from           @"from"
#define DICT_to             @"to"
#define DICT_info           @"info"
#define DICT_content        @"content"
#define DICT_memberList     @"memberList"
#define DICT_clientMsgId    @"clientMsgId"
#define DICT_createDate     @"createDate"
#define DICT_type           @"type"

#define DICT_appName        @"appName"
#define DICT_userName       @"userName"
#define DICT_modified       @"modified"
#define DICT_nickName       @"nickName"

@interface ChatMsgManager()

@property (nonatomic, copy)  NSString  *anotherName; // <##>
@property (nonatomic)  BOOL  alive; // 是否活跃

/// 消息处理队列
@property (nonatomic, strong) dispatch_queue_t messageParseQueue;

@end

@implementation ChatMsgManager

// 单例
+ (ChatMsgManager *)share
{
    static ChatMsgManager *chatMsgManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        chatMsgManager = [[ChatMsgManager alloc] init];
    });
    
    if (chatMsgManager.anotherName.length <=0 || !chatMsgManager.alive) {
        chatMsgManager.anotherName = [[MsgUserInfoMgr share] getUid];
    }
    
    if (!chatMsgManager.alive) {
        chatMsgManager.alive = YES;
    }
    
    return chatMsgManager;
}

// 退出登录等数据重置
- (void)destroyMyself
{
    self.alive = NO;
    self.anotherName = nil;
    [self setDelegate:nil];
}

// 单例被销毁时
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MTWebsocketLogoutNotification object:nil];
}

- (instancetype)init
{
    if (self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(destroyMyself) name:MTWebsocketLogoutNotification object:nil];
    }
    return self;
}

// 处理收到的消息
- (void)parseReceiveMessage:(id)message
{
    PRINT_STRING(@"\n\n\n\n\n\n\n");
    PRINT_STRING_DOUBLE(@"Receive---＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊", message);
    
    // 转换格式得到 消息基础Model
    NSDictionary *dict_rev = [message mt_im_objectFromJSONString];
    MessageBaseModel *baseModel = [[MessageBaseModel alloc] initWithDict:dict_rev];
    baseModel.lastMsg = message;
    baseModel._isOfflineMsg = NO;
    
    // 解析分离单条消息
    [self separateSingleMessage:baseModel];
}

// 批量处理收到的离线消息（处理流程参照接受单挑消息方法）（已经停用离线机制）
- (void)parseOffLineMessages:(NSArray *)messages DEPRECATED_ATTRIBUTE
{
    // 筛选分离各类消息
    for (MessageBaseModel *baseModel in messages)
    {
        baseModel._isOfflineMsg = YES;
        // 解析分离单条消息
        [self separateSingleMessage:baseModel];
    }
}

// 解析分类单条数据
- (void)separateSingleMessage:(MessageBaseModel *)baseModel
{
    // loginIn
    if (baseModel._type == msg_manager_loginIn)
    {
        // 发送委托提示
        if ([self.delegate respondsToSelector:@selector(ChatMsgManagerDelegateCallBack_wsLoginIn)])
        {
            [self.delegate ChatMsgManagerDelegateCallBack_wsLoginIn];
        }
    }
    
    // loginOut
    else if (baseModel._type == msg_manager_loginOut)
    {
        // 发送委托提示
        if ([self.delegate respondsToSelector:@selector(ChatMsgManagerDelegateCallBack_wsLoginOutWithContent:)])
        {
            [self.delegate ChatMsgManagerDelegateCallBack_wsLoginOutWithContent:baseModel._content];
        }
    }
    
    // loginKeep
    else if (baseModel._type == msg_manager_loginKeep)
    {
        //        [[MsgSqlMgr share] insertMsgIdWith:baseModel];
        
        if ([self.delegate respondsToSelector:@selector(ChatMsgManagerDelegateCallBack_receiveLoginKeepSuccess)])
        {
            [self.delegate ChatMsgManagerDelegateCallBack_receiveLoginKeepSuccess];
        }
    }
    
    // rev 发送消息成功回执
    else if (baseModel._type == msg_manager_rev)
    {
        baseModel._target = self.anotherName;
        baseModel._fromLoginName = self.anotherName;
        if ([self.delegate respondsToSelector:@selector(ChatMsgManagerDelegateCallBack_receiveFinishSendWithBaseModel:)])
        {
            [self.delegate ChatMsgManagerDelegateCallBack_receiveFinishSendWithBaseModel:baseModel];
        }
    }
    
    else if (baseModel._type == msg_cmd_clear)
    {
        // 删除聊天记录
        if ([self.delegate respondsToSelector:@selector(ChatMsgManagerDelegateCallBack_receiveClearMessages:)])
        {
            [self.delegate ChatMsgManagerDelegateCallBack_receiveClearMessages:baseModel];
        }

    }
    
    // 已读信息处理 更新数据库
    else if (baseModel._type == msg_cmd_read)
    {
        if ([self.delegate respondsToSelector:@selector(ChatMsgManagerDelegateCallBack_receiveReadedMessages:)])
        {
            [self.delegate ChatMsgManagerDelegateCallBack_receiveReadedMessages:baseModel];
        }
    }
    
    // 已打开会话 该消息列表消息未读置空
    else if (baseModel._type == msg_cmd_open)
    {
        if ([self.delegate respondsToSelector:@selector(ChatMsgManagerDelegateCallBack_receiveOpenMessages:)])
        {
            [self.delegate ChatMsgManagerDelegateCallBack_receiveOpenMessages:baseModel];
        }
    }
    
    // 已标记信息处理 更新数据库
    else if (baseModel._type == msg_cmd_mark)
    {
        if ([self.delegate respondsToSelector:@selector(ChatMsgManagerDelegateCallBack_receiveMarkedMessages: important:)])
        {
            [self.delegate ChatMsgManagerDelegateCallBack_receiveMarkedMessages:baseModel important:YES];
        }
    }
    
    // 取消标记 更新数据库
    else if (baseModel._type == msg_cmd_cancelMark)
    {

        if ([self.delegate respondsToSelector:@selector(ChatMsgManagerDelegateCallBack_receiveMarkedMessages: important:)])
        {
            [self.delegate ChatMsgManagerDelegateCallBack_receiveMarkedMessages:baseModel important:NO];
        }
    }
    
    // 移除会话
    else if (baseModel._type == msg_cmd_remove) {
        if ([self.delegate respondsToSelector:@selector(ChatMsgManagerDelegateCallBack_receiveRemoveMessage:)]) {
            [self.delegate ChatMsgManagerDelegateCallBack_receiveRemoveMessage:baseModel];
        }
    }
    
    // 撤回重发(暂时接撤回消息)
    else if (baseModel._type == msg_personal_reSend) {
        if ([self.delegate respondsToSelector:@selector(ChatMsgManagerDelegateCallBack_receiveReSendMessage:)]) {
            [self.delegate ChatMsgManagerDelegateCallBack_receiveReSendMessage:baseModel];
        }
    }
    
    // 好友关系
    else if (baseModel._type == msg_cmd_relation) {
        if ([self.delegate respondsToSelector:@selector(ChatMsgManagerDelegateCallBack_receiveRelationMessage:)]) {
            [self.delegate ChatMsgManagerDelegateCallBack_receiveRelationMessage:baseModel];
        }
    }
    
    else if (baseModel._type < msg_usefulMsgMax)
    {
        if (baseModel._type == msg_usefulMsgMin) {
            // 不识别类型，不做处理
            return;
        }
        
        if (baseModel._type == msg_personal_voip) {
            if (baseModel.voipModel.state == 0) {
                // 不做处理
                return;
            }
        }
        
        // 自己发送的同步消息
        if ([baseModel._fromLoginName isEqualToString:self.anotherName])
        {
            // 处理需要同步的消息
            [self manageSyncMessage:baseModel];
        }
        // 别人发来的数据消息
        else
        {
            // 处理数据
            [self managerMessageDataWithMessageBaseModel:baseModel];
        }
    }
}

// 处理需要同步的数据
- (void)manageSyncMessage:(MessageBaseModel *)baseModel {
    // 转发委托
    if ([self.delegate respondsToSelector:@selector(ChatMsgManagerDelegateCallBack_receiveMessageSynch:)])
    {
        [self.delegate ChatMsgManagerDelegateCallBack_receiveMessageSynch:baseModel];
    }
}

// 处理解析好的数据
- (void)managerMessageDataWithMessageBaseModel:(MessageBaseModel *)baseModel
{
    // 标记接收
    [baseModel set_markFromReceive:YES];
    [baseModel set_target:baseModel._fromLoginName];
    
    dispatch_async(self.messageParseQueue, ^{
        // 查找数据库过滤重复消息
        BOOL isExsit = [[MsgSqlMgr share] queryMessageIsExsitWithBaseModel:baseModel];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isExsit)    // update
            {
                // 直接发送更新委托
                if ([self.delegate respondsToSelector:@selector(ChatMsgManagerDelegateCallBack_receiveUpdateMessageWithMessageModel:)])
                {
                    [self.delegate ChatMsgManagerDelegateCallBack_receiveUpdateMessageWithMessageModel:baseModel];
                }
            }
            else    // insert / download / manager
            {
                // 2.1.1 Audio,Attach/Image,Video,File,Text,Alert  通过委托回调送回
                if (baseModel._type < msg_personal_event)
                {
                    if (baseModel._type == msg_personal_alert || baseModel._type == msg_personal_text)
                    {
                        [baseModel set_markCompleted:YES];
                    }
                    else
                    {
                        [baseModel set_markCompleted:NO];
                    }
                    
                    // 发送收到消息显示的委托
                    if ([self.delegate respondsToSelector:@selector(ChatMsgManagerDelegateCallBack_receiveMessageWithMessageModel:)])
                    {
                        [self.delegate ChatMsgManagerDelegateCallBack_receiveMessageWithMessageModel:baseModel];
                    }
                    
                }
                
                // 2.1.2 任务,通过委托显示到会话列表
                else if ([baseModel isEventType])
                {
                    [baseModel set_markCompleted:YES];
                    
                    if ([self.delegate respondsToSelector:@selector(ChatMsgManagerDelegateCallBack_receiveMessageWithMessageModel:)])
                    {
                        [self.delegate ChatMsgManagerDelegateCallBack_receiveMessageWithMessageModel:baseModel];
                    }
                }
            }
        });
    });
}

// 登录WebSocket
- (void)login
{
    NSMutableDictionary *dictLogin = [NSMutableDictionary dictionary];
    dictLogin[DICT_appName]     = [[MsgUserInfoMgr share] getAppName];
    dictLogin[DICT_userName]    = [[MsgUserInfoMgr share] getUid];
    dictLogin[DICT_content]     = [[MsgUserInfoMgr share] getToken];
    dictLogin[DICT_MSGID]       = @([[[MsgUserInfoMgr share] getMaxMsgId] longLongValue] + 1);// 服务器会把maxMsgId的消息也发过来,所以加1
    dictLogin[DICT_clientMsgId] = [NSNumber numberWithLongLong:[NSDate wzim_currentTimestamp]];
    dictLogin[DICT_type]        = [MessageBaseModel getStringFromMsgType:msg_manager_login];
    dictLogin[DICT_info]        = [@{DICT_nickName:[[MsgUserInfoMgr share] getNickName]} mj_JSONString];
    dictLogin[DICT_modified]    = [[MsgUserInfoMgr share] getModified];
    NSString *str_send          = [dictLogin mj_JSONString];
    PRINT_STRING(@"\n\n");
    PRINT_STRING_DOUBLE(@"\nsendLogin----", str_send);
    
    // 委托发送webSocket操作消息
    if ([self.delegate respondsToSelector:@selector(ChatMsgManagerDelegateCallBack_sendMessageForConnection:)])
    {
        [self.delegate ChatMsgManagerDelegateCallBack_sendMessageForConnection:str_send];
    }
}

// 心跳包
- (void)loginKeep
{
    NSMutableDictionary *dictLogin = [NSMutableDictionary dictionary];
    dictLogin[DICT_MSGID] = [[MsgUserInfoMgr share] getMaxMsgId];
    dictLogin[DICT_type] = [MessageBaseModel getStringFromMsgType:msg_manager_loginKeep];
    
    NSString *str_send = [dictLogin mj_JSONString];
    
    PRINT_STRING(@"\n\n");
    PRINT_STRING_DOUBLE(@"\nsendLoginKeep----", str_send);
    
    // 委托发送webSocket操作消息
    if ([self.delegate respondsToSelector:@selector(ChatMsgManagerDelegateCallBack_sendMessageForConnection:)])
    {
        [self.delegate ChatMsgManagerDelegateCallBack_sendMessageForConnection:str_send];
    }
}

// 发送消息（文本、语音、图片、应用消息共用了）
- (void)sendMessageTo:(NSString *)toLoginName NickName:(NSString *)nickName WithContent:(NSString *)content Type:(Msg_type)msgType atUserList:(NSArray *)atUserList
{
    // webSocket
    if (msgType < msg_usefulMsgMax)
    {
        long long msgId = [[[MsgUserInfoMgr share] getMaxMsgId] longLongValue] + 1;
        long long cid = [NSDate wzim_currentTimestamp];
        NSString *from = [[MsgUserInfoMgr share] getUid];
        NSString *to = toLoginName;
        long long lastSendingCid = [[MsgUserInfoMgr share] getCid];
        
        // 防重复
        if (lastSendingCid == cid) {
            cid ++;
        }
        
        [[MsgUserInfoMgr share] saveCid:cid];
        
        if (msgType > msg_personal_event)
        {
            msgType = msg_personal_event;
            MessageAppModel *appModel = (id)content;
            NSMutableDictionary *dict = [appModel mj_keyValuesWithIgnoredKeys:@[@"applicationDetailDictionary"]];
            if (dict[@"msgInfo"]) {
                dict[@"msgInfo"] = [dict[@"msgInfo"] mt_im_objectFromJSONString];
            }
            
            content = [dict mj_JSONString];
        }
        
        NSMutableDictionary *dictSend = [NSMutableDictionary dictionary];
        dictSend[DICT_MSGID] = [NSNumber numberWithLongLong:msgId];
        dictSend[DICT_clientMsgId] = [NSNumber numberWithLongLong:cid];
        dictSend[DICT_type] = [MessageBaseModel getStringFromMsgType:msgType];
        dictSend[DICT_from] = from;
        dictSend[DICT_to] = to;
        dictSend[DICT_content] = content;
        if (atUserList) {
            dictSend[@"info"] = [@{@"atUsers":atUserList} mj_JSONString];
        }
        
        NSString *str_send = [dictSend mj_JSONString];
        PRINT_STRING(@"\n\n");
        PRINT_STRING_DOUBLE(@"\nsendText----", str_send);
        
        // 生成 MessageBaseModel
        MessageBaseModel *baseModel = [[MessageBaseModel alloc] init];
        baseModel._fromLoginName = from;
        baseModel._toLoginName = to;
        baseModel._target = to;
        baseModel._markFromReceive = NO;
        baseModel._msgId = msgId;
        baseModel._content = content;
        baseModel._clientMsgId = cid;
        baseModel._createDate = cid;
        baseModel._type = msgType;
        baseModel._markStatus = status_sending;
        NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         [[MsgUserInfoMgr share] getNickName],@"nickName",
                                         from,@"userName",nil];
        if (atUserList) {
            [infoDict setObject:atUserList forKey:@"atUsers"];
        }
        
        baseModel._info = [infoDict mj_JSONString];
        
        // 生成 ContactDetailModel
        ContactDetailModel *contactModel = [[ContactDetailModel alloc] initWithMessageBaseModel:baseModel];
        contactModel._nickName = nickName;
        // 委托发送消息
        if ([self.delegate respondsToSelector:@selector(ChatMsgManagerDelegateCallBack_sendMessage:ContactModel:BaseModel:)])
        {
            [self.delegate ChatMsgManagerDelegateCallBack_sendMessage:str_send ContactModel:contactModel BaseModel:baseModel];
        }
    }
}

- (MessageBaseModel *)anchorAttachMessageType:(Msg_type)type
                                     toTarget:(NSString *)toTarget
                                     nickName:(NSString *)nickName
                                  primaryPath:(NSString *)primaryPath
                                    minorPath:(NSString *)minorPath
{
    long long msgId = [[[MsgUserInfoMgr share] getMaxMsgId] longLongValue] + 1;
    long long cid = [NSDate wzim_currentTimestamp];
    NSString *from = [[MsgUserInfoMgr share] getUid];
    long long lastCid = [[MsgUserInfoMgr share] getCid];
    
    if (cid == lastCid) {
        cid ++;
    }
    
    [[MsgUserInfoMgr share] saveCid:cid];
    
    // 生成 MessageBaseModel
    MessageBaseModel *baseModel = [[MessageBaseModel alloc] init];
    baseModel._fromLoginName = from;
    baseModel._toLoginName = toTarget;
    baseModel._target = toTarget;
    baseModel._markFromReceive = NO;
    baseModel._msgId = msgId;
    baseModel._content = @"";
    baseModel._clientMsgId = cid;
    baseModel._createDate = cid;
    baseModel._type = type;
    baseModel._markStatus = status_send_waiting;
    baseModel._nativeOriginalUrl = primaryPath;
    baseModel._nativeThumbnailUrl = minorPath;
    
    NSDictionary *infoDict = @{@"nickName" : [[MsgUserInfoMgr share] getNickName],@"userName":from};
    baseModel._info = [infoDict mj_JSONString];
    // 生成 ContactDetailModel
    ContactDetailModel *contactModel = [[ContactDetailModel alloc] initWithMessageBaseModel:baseModel];
    contactModel._nickName = nickName;
    
    // 委托
    if ([self.delegate respondsToSelector:@selector(ChatMsgManagerDelegateCallBack_anchorAttachMessageWithContactModel:baseModel:)])
    {
        [self.delegate ChatMsgManagerDelegateCallBack_anchorAttachMessageWithContactModel:contactModel baseModel:baseModel];
    }
    
    return baseModel;

}

- (void)unmoorAttachMessageModel:(MessageBaseModel *)baseModel content:(NSString *)content {
    // msgId 和 cid 要换掉
    long long msgId = [[[MsgUserInfoMgr share] getMaxMsgId] longLongValue] + 1;
    
    NSMutableDictionary *dictSend = [NSMutableDictionary dictionary];
    dictSend[DICT_MSGID] = [NSNumber numberWithLongLong:msgId];
    dictSend[DICT_clientMsgId] = [NSNumber numberWithLongLong:baseModel._clientMsgId];
    dictSend[DICT_type] = [MessageBaseModel getStringFromMsgType:baseModel._type];
    dictSend[DICT_from] = baseModel._fromLoginName;
    dictSend[DICT_to] = baseModel._toLoginName;
    dictSend[DICT_content] = content;
    
    NSString *str_send = [dictSend mj_JSONString];
    PRINT_STRING(@"\n\n");
    PRINT_STRING_DOUBLE(@"\nsendText----", str_send);
    
    // MessageBaseModel 更新内容
    baseModel._msgId = msgId;
    baseModel._content = content;
    baseModel._markStatus = status_sending;
    
    // 委托发送消息
    if ([self.delegate respondsToSelector:@selector(ChatMsgManagerDelegateCallBack_unmoorAttachMessageWithBaseModel:socketMessage:)])
    {
        [self.delegate ChatMsgManagerDelegateCallBack_unmoorAttachMessageWithBaseModel:baseModel socketMessage:str_send];
    }
}

/**
 *  发送用户信息更改消息
 *
 *  @return 用户消息更改后的modified
 */
- (void)sendUserModified:(long long)modified
{
    NSMutableDictionary *dictSend = [NSMutableDictionary dictionary];
    dictSend[DICT_type] = [MessageBaseModel getStringFromMsgType:msg_personal_modified];
    dictSend[DICT_modified] = [NSNumber numberWithLongLong:modified];
    
    NSString *str_send = [dictSend mj_JSONString];
    PRINT_STRING(@"\n\n");
    PRINT_STRING_DOUBLE(@"\nsendText----", str_send);
    // 委托发送消息
    if ([self.delegate respondsToSelector:@selector(ChatMsgManagerDelegateCallBack_sendUserModified:)])
    {
        [self.delegate ChatMsgManagerDelegateCallBack_sendUserModified:str_send];
    }
}

#pragma mark - Private Method
// 生成WebSocket标准格式
- (NSString *)getWebSocketMessegeWithMsgId:(long long)msgId From:(NSString *)fromName To:(NSString *)toName Info:(NSString *)info Content:(NSString *)content Cid:(long long)cid CreateDate:(long long)createDate Type:(Msg_type)type
{
    // 根据Msg_type得到String字段
    
    
    // 封装
    NSDictionary *dict_send = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithLongLong:msgId], DICT_MSGID,
                               fromName, DICT_from,
                               toName, DICT_to,
                               info, DICT_info,
                               content, DICT_content,
                               [NSNumber numberWithLongLong:cid], DICT_clientMsgId,
                               [NSNumber numberWithLongLong:createDate], DICT_createDate,
                               [MessageBaseModel getStringFromMsgType:type], DICT_type,
                               nil];
    
    NSString *str_send = [dict_send mj_JSONString];
    
    return str_send;
}

#pragma mark - Initializer
- (dispatch_queue_t)messageParseQueue {
    if (!_messageParseQueue) {
        _messageParseQueue = dispatch_queue_create("IM.parse", DISPATCH_QUEUE_SERIAL);
    }
    return _messageParseQueue;
}

@end
