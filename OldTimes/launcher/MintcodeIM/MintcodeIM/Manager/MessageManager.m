//
//  MessageManager.m
//  Titans
//
//  Created by Remon Lv on 14-9-2.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//

#import "MessageManager.h"
#import "MsgDefine.h"
#import "MsgUserInfoMgr.h"
#import "MsgSqlMgr.h"
#import "ContactDetailModel.h"
#import "UnifiedNetworkManager.h"
#import "MessageTimerManager.h"
#import "MessageOfflineDAL.h"
#import "SocketManager.h"
#import "ChatMsgManager.h"
#import "AudioDownloadManager.h"
#import "VoiceConverter.h"
#import "MsgFilePathMgr.h"
#import "GetSessionUserProfileDAL.h"
#import "AttachmentDownloadDAL.h"
#import "GetHistoryMessageRequest.h"
#import "SetMessageReadRequest.h"
#import "GetUnreadSessionRequest.h"
#import "IMApplicationManager.h"
#import "SendMessageManager.h"
#import "ContactDetailModel+Extension.h"
#import "MessageBaseModel+Extension.h"
#import "IMLoginDAL.h"
#import "IMConfigure.h"
#import "RemoveSessionRequest.h"
#import "AddGroupUserRequest.h"
#import "CreateGroupRequest.h"
#import "IMUploadFileSessionManager.h"
#import "AttachmentUploadModel.h"
#import "IMAttachmentUploadRequest.h"
#import "IMMessageMarkRequest.h"
#import "RecallMessageRequest.h"
#import "IMLoginOutRequest.h"
#import "DeleteGroupUserRequest.h"
#import "UpdateGroupNameRequest.h"
#import "MessageGroupNoDisturbRequest.h"
#import "UnifiedNetworkManager.h"
#import "AudioMessageManager.h"
#import "ASJSONKitManager.h"
#import "MessageManagerPrivate.h"
#import "GetFriendInfolistRequest.h"
#import "AddRelationValidateRequest.h"
#import "SearchRelationUserRequest.h"
#import "RelationValidateListRequest.h"
#import "LoadRelationGroupInfoRequest.h"
#import "DisposeRelationValidateRequest.h"
#import "DeleteRelationRequest.h"
#import "RemarkRelationRequest.h"
#import "MessageMergeForwardRequest.h"
#import "RelationGroupInfoRequest.h"
#import "CreateRelationGroupRequest.h"
#import "GetGroupListRequest.h"
#import "DeleteRelationGroupRequest.h"
#import "modifyRelationGroupRequest.h"
#import "FriendsTransferRelationRequest.h"
#import "GetSuperGroupListRequest.h"
#import "SuperGroupListModel.h"
/// 角标总数变化
NSString *const MTBadgeCountChangedNotification = @"MTBadgeCountChangedNotification";
/**
 *  用户信息变更，主要用于用户头像缓存清理 notifcation中object:targetId
 */
NSString *const MTUserInfoChangeNotification = @"MTUserInfoChangeNotification";

@interface MessageManager () <MessageTimerManagerDelegate,MessageOfflineDALDelegate,SocketManagerDelegate,ChatMsgManagerDelegate,AudioDownloadManagerDelegate,AttachmentDownloadDALDelegate,IMBaseRequestDelegate, IMUploadFileSessionManagerDelegate>
{
    NSTimer *_timerLogin;                       // socket登录定时器
}

@property (nonatomic, strong)  MessageOfflineDAL  *msgOfflineDAL;          // 离线消息请求器
@property (nonatomic, strong) AudioDownloadManager *audioDownloadManager;  // 音频资源下载管理
@property (nonatomic, strong) AttachmentDownloadDAL *attachmentDAL;        // 附件下载请求器

@property (nonatomic, strong) dispatch_queue_t offlineQueue;               // 离线

@property (nonatomic)  BOOL  alive;

/// 获取本地历史 默认（NO）
/// 在一个会话中失败后就获取本地，退出重置
@property (nonatomic, assign) BOOL getLocalHistory;
/// 拉历史时的最老的一条时间戳 default -1
@property (nonatomic, assign) long long oldestTimeStamp;

/// 需要忽略缓存的字典
@property (nonatomic, strong) NSMutableDictionary *ignoreCacheRequestDictionary;

@end

@implementation MessageManager

// 单例
+ (MessageManager *)share
{
    static MessageManager *messageManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        messageManager = [[MessageManager alloc] init];
    });
    if (!messageManager.alive) {
        messageManager.alive = YES;
        // 初始化几个单例
        [[SocketManager share] setDelegate:messageManager];
        [[ChatMsgManager share] setDelegate:messageManager];
        [[MessageTimerManager share] setDelegate:messageManager];
    }
    return messageManager;
}

+ (void)setApplicationConfig:(NSDictionary *)dictionary {
    [IMApplicationManager setApplicationConfig:dictionary];
}

+ (void)setAppName:(NSString *)appName appToken:(NSString *)appToken wsIP:(NSString *)wsIP httpIP:(NSString *)httpIP testIP:(NSString *)testIP loginType:(NSString *)loginType {
    [[MsgUserInfoMgr share] saveAppName:appName];
    [[MsgUserInfoMgr share] saveAppToken:appToken];
    [[MsgUserInfoMgr share] saveWsIp:wsIP];
    [[MsgUserInfoMgr share] saveHttpIp:httpIP];
    [[MsgUserInfoMgr share] saveTestIp:testIP];
    [[MsgUserInfoMgr share] setLoginType:loginType];
    
    // 第一次启动程序，将所有发送中的消息设置为失败
    [[MsgSqlMgr share] markMessageStatusSendingToFailed];
}

+ (void)setRemoteNotificationWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [NSString stringWithFormat:@"%@",deviceToken];
    token = [[token substringWithRange:NSMakeRange(0, 72)] substringWithRange:NSMakeRange(1, 71)];
    
    // 去掉空格
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[MsgUserInfoMgr share] setRemoteNotifyToken:token];
}

+ (void)setVoipDeviceWithToken:(NSString *)voipToken {
    [[MsgUserInfoMgr share] setVoipToken:voipToken];
}

+ (void)setUserId:(NSString *)userId nickName:(NSString *)nickName {
    [[MsgUserInfoMgr share] saveUid:userId];
    [[MsgUserInfoMgr share] saveNickName:nickName];
}

+ (NSString *)getUserID
{
   return [[MsgUserInfoMgr share] getUid];
}

+ (NSString *)getNickName
{
    return [[MsgUserInfoMgr share] getNickName];
}

- (instancetype)init
{
    if (self = [super init])
    {
        [IMUploadFileSessionManager share].delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(destroyMyself) name:MTWebsocketLogoutNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netChanged:) name:kReachabilityChangedNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationTerminate:) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicaionDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)destroyMyself
{
    self.alive = NO;
    [_timerLogin invalidate];
    [self setDelegate:nil];
    [_audioDownloadManager setDelegate:nil];
    _audioDownloadManager = nil;
}

- (void)login {
    [IMLoginDAL loginCompletion:^(IMBaseResponse *response, BOOL success) {
        if (!success) {
            return;
        }
        
        [self setToken:[(id)response token]];
        [[MsgUserInfoMgr share] setVoipUid:[(id)response uid]];
        [self loadRelationGroupInfoWithTotalFlag:NO Completion:nil];
        [self getMessageList];
    }];
}

- (void)logout {
    [IMLoginOutRequest logout];
    [[NSNotificationCenter defaultCenter] postNotificationName:MTWebsocketLogoutNotification object:nil];
}

- (void)setToken:(NSString *)token
{
    if ([token length]) {
        [[MsgUserInfoMgr share] saveToken:token];
    }
    
    // 获取个人消息
    [self getUserInfoWithUid:[[MsgUserInfoMgr share] getUid]];
}

/**
 *  用户信息更改后更改NickName
 *
 *  @param nickName 更改后的nickName
 */
- (void)setNickName:(NSString *)nickName
{
    [[MsgUserInfoMgr share] saveNickName:nickName];
}


- (NSDictionary *)attachUploadProgressDictionary {
    return [IMUploadFileSessionManager share].uploadImageProgressDictionary;
}

// ************** http请求 **************//

- (void)removeSessionUid:(NSString *)deleteSessionUid completion:(void (^)(BOOL))completion {
    [RemoveSessionRequest removeSessionName:deleteSessionUid completion:^(IMBaseResponse *response, BOOL success) {
        if (success) {
            [self deleteMessageListWithUid:deleteSessionUid];
        }
        
        !completion ?: completion(success);
    }];
}

- (void)createGroupWithUserIds:(NSArray *)userIds completion:(void (^)(UserProfileModel *, BOOL))completion {
    [self createGroupWithUserIds:userIds tag:nil completion:completion];
}
- (void)createGroupWithUserIds:(NSArray *)userIds tag:(NSString *)tag completion:(void (^)(UserProfileModel *, BOOL))completion {
    NSAssert(userIds.count > 1, @"创建群群成员不能小于2人");
    NSMutableArray *userIdsIncludeMe = [NSMutableArray arrayWithObject:[[MsgUserInfoMgr share] getUid]];
    [userIdsIncludeMe addObjectsFromArray:userIds];
    [CreateGroupRequest createWithUserIds:userIdsIncludeMe tag:tag completion:^(IMBaseResponse *response, BOOL success) {
        if (!success) {
            !completion ?: completion(nil ,NO);
            return;
        }
        
        [GetSessionUserProfileDAL sessionid:[(id)response groupUid]
                                 completion:^(UserProfileModel *userProfile)
         {
             [self saveGroupModel:userProfile];
             !completion ?: completion(userProfile, YES);
         }];
    }];
}

- (void)groupSessionUid:(NSString *)groupUid addUserIds:(NSArray *)userIds completion:(void (^)(BOOL))completion {
    [AddGroupUserRequest sessionName:groupUid addUserIds:userIds completion:^(IMBaseResponse *response, BOOL success) {
        !completion ?: completion(success);
    }];
}

- (void)groupSessionUid:(NSString *)groupUid deleteMemberId:(NSString *)memberId completion:(void (^)(BOOL))completion {
    [DeleteGroupUserRequest deleteGroupSessionName:groupUid memeberId:memberId completion:^(IMBaseResponse *response, BOOL success) {
        
        if (success && [memberId isEqualToString:[[MsgUserInfoMgr share] getUid]]) {
            [self deleteMessageListWithUid:groupUid];
        }
        
        !completion ?: completion(success);
    }];
}

- (void)groupSessionUid:(NSString *)groupUid changeName:(NSString *)changedName {
    [UpdateGroupNameRequest updateGroupUid:groupUid name:changedName completion:^(IMBaseResponse *response, BOOL success) {
        
    }];
}

- (void)groupSessionUid:(NSString *)groupUid receiveMode:(userProfileReceiveMode)receiveMode completion:(void (^)(BOOL))completion {
    [MessageGroupNoDisturbRequest noDisturbSessionName:groupUid receiveMode:receiveMode completion:^(IMBaseResponse *response, BOOL success) {
        if (success) {
            ContactDetailModel *model = [ContactDetailModel new];
            model._target = groupUid;
            model._muteNotification = receiveMode;
            [self updateMuteNotification:model];
        }
        
        !completion ?: completion(success);
    }];
}

- (void)markMessage:(MessageBaseModel *)message {
    [self markMessage:message completion:nil];
}

- (void)markMessage:(MessageBaseModel *)message completion:(void (^)(BOOL))completion {
    [IMMessageMarkRequest markMessageModel:message completion:^(IMBaseResponse *response, BOOL success) {
        !completion ?: completion(success);
    }];
}

- (void)recallMessage:(MessageBaseModel *)message completion:(void (^)(BOOL))completion {
    [RecallMessageRequest recallMessage:message completion:^(IMBaseResponse *response, BOOL success) {
        !completion ?: completion(success);
    }];
}

- (void)forwardMergeMessages:(NSArray <MessageBaseModel *>*)messages
                       title:(NSString *)title
                     toUsers:(NSArray <ContactDetailModel *>*)toUsers
                     isMerge:(BOOL)isMerge
                  completion:(void (^)(BOOL))completion
{
    NSMutableArray *arrayUsers = [NSMutableArray array];
    
    for (ContactDetailModel *user in toUsers) {
        [arrayUsers addObject:user._target];
    }
    
    [MessageMergeForwardRequest forwardMessages:messages
                                          title:title
                                        toUsers:arrayUsers
                                        isMerge:isMerge
                                     completion:^(IMBaseResponse *response, BOOL success)
    {
        !completion ?: completion(success);
    }];
}

// ************** http请求 **************//

/**
 *  设置欢迎语句
 *
 *  @param welcomeMessage 欢迎语句
 */
- (void)setWelcomeMessage:(NSString *)welcomeMessage uid:(NSString *)uid nickName:(NSString *)nickName
{
    [self queryBatchMessageWithUid:uid MessageCount:2 completion:^(NSArray *arrayTemp) {
        if (arrayTemp.count == 0)
        {
            long long msgId = [[[MsgUserInfoMgr share] getMaxMsgId] longLongValue] + 1;
            long long cid = [[NSDate date] timeIntervalSince1970] * 1000;
            NSString *from = uid;
            NSString *to = [[MsgUserInfoMgr share] getUid];
            
            // 生成 MessageBaseModel
            MessageBaseModel *baseModel = [[MessageBaseModel alloc] init];
            baseModel._fromLoginName = from;
            baseModel._toLoginName = to;
            baseModel._target = from;
            baseModel._markFromReceive = NO;
            baseModel._msgId = msgId;
            baseModel._content = welcomeMessage;
            baseModel._clientMsgId = cid;
            baseModel._createDate = cid;
            baseModel._type = msg_personal_text;
            baseModel._markStatus = status_receive_success;
            
            // 生成 ContactDetailModel
            ContactDetailModel *contactModel = [[ContactDetailModel alloc] initWithMessageBaseModel:baseModel];
            contactModel._nickName = nickName;
            
            // 1.写入消息列表
            [[MsgSqlMgr share] insertBatchData:[NSArray arrayWithObject:baseModel] WithTag:table_msg];
            
            // 2.写入联系人列表
            [[MsgSqlMgr share] writeMessageListInfoToContactTableWith:contactModel];
            
            // 3.发送委托刷新显示
            if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_needRefreshWithTareget:)])
            {
                [self.delegate MessageManagerDelegateCallBack_needRefreshWithTareget:baseModel._target];
            }
        }
    }];
}

/**
 *  查询某一个用户信息，并存入联系人列表
 *
 *  @param target 联系人uid
 */
- (void)getUserInfoWithUid:(NSString *)uid
{
    [GetSessionUserProfileDAL sessionid:uid completion:^(UserProfileModel *userProfile) {
       
        dispatch_async(self.messageQueue, ^{
            [[MsgSqlMgr share] updateContactInfoToContactTable:@[userProfile]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 发送刷新委托
                if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_refreshContactProfileRefresh:)])
                {
                    [self.delegate MessageManagerDelegateCallBack_refreshContactProfileRefresh:userProfile];
                }
            });
        });
    }];
}

/**
 *  获取群组列表
 *
 *  @param completion 完成后的回调
 */
- (void)getSuperGroupListFromChache:(BOOL)fromChache completion:(void (^)(BOOL success, NSArray <SuperGroupListModel *> *modelArray))completion
{
    [GetSuperGroupListRequest GetSuperGroupListFromChache:fromChache Completion:^(IMBaseResponse *response, BOOL success) {
        if (!success) {
            completion(success,nil);
            return ;
        }
        NSArray *tempArray = [(GetSuperGroupListResponse *)response modelArray];
        completion(success,tempArray);
    }];
}


#pragma mark - WebSocket Manager

/// 网络变化
- (void)netChanged:(NSNotification *)notification {
    NetworkStatus status = [UnifiedNetworkManager getNetworkCurrentStatus];
    if (status == NotReachable) {
        [self closeSocket];
    } else {
        [self getMessageList];
    }
}

- (void)openSocket
{
    [[SocketManager share] openSocket];
}
- (void)closeSocket
{
    // 关闭心跳轮询
    [_timerLogin invalidate];
    
    // 关闭超时检测
    [[MessageTimerManager share] stopLoginTimer];
    
    // 关闭socket
    [[SocketManager share] closeSocket];
}

- (void)socketLogin
{
    // 清理发送状态（未发送成功的都标记为发送失败）
    // [[MsgSqlMgr share] markMessageStatusSendingToFailed];
    
    // 网络通畅时
    if ([UnifiedNetworkManager getNetworkCurrentStatus])
    {
        // login
        [[ChatMsgManager share] login];
        
        // 同时开启login超时检测器
        [[MessageTimerManager share] startLoginTimer];
    }
}

- (void)loginKeep
{
    // 清理发送状态（未发送成功的都标记为发送失败）
    // [[MsgSqlMgr share] markMessageStatusSendingToFailed];
    // 循环登录
    if (_timerLogin != nil)
    {
        [_timerLogin invalidate];
        _timerLogin = nil;
    }
    _timerLogin = [NSTimer scheduledTimerWithTimeInterval:M_V_loginKeep_duration target:self selector:@selector(loopLoginKeep) userInfo:nil repeats:YES];
    // 立即执行
//    [_timerLogin fire];
}

/** 轮询登录
 */
- (void)loopLoginKeep
{
    // 网络通畅时 心跳检测
    if ([UnifiedNetworkManager getNetworkCurrentStatus])
    {
        // 发送心跳
        [[ChatMsgManager share] loginKeep];
        
        // 同时开启心跳超时检测器
        [[MessageTimerManager share] startLoginKeepTimer];
    }
}

/**
 *  发送最后一次心跳
 */
- (void)sendLastHeartbeat
{
    // 发送心跳
    [[ChatMsgManager share] loginKeep];
    
    // 关闭socket
    [[MessageManager share] closeSocket];
}

- (void)applicationTerminate:(NSNotification *)notification {
    [self closeSocket];
}

- (void)applicaionDidEnterBackground:(NSNotification *)notification {
    [self closeSocket];
}

#pragma mark - MessageSolve Method
- (void)parseOfflineMessages:(NSArray *)messages
{
    for (MessageBaseModel *baseModel in messages)
    {
        baseModel._isOfflineMsg = YES;
        switch ((NSInteger)baseModel._type) {
            case msg_cmd_read:
                [self solveReadType:baseModel];
                break;
                
            case msg_cmd_open:
                [self solveOpenType:baseModel];
                break;
                
            case msg_cmd_mark:
                [self solveMarkType:baseModel Important:YES];
                break;
                
            case msg_cmd_cancelMark:
                [self solveMarkType:baseModel Important:NO];
                break;
                
            case msg_personal_text:
            case msg_personal_image:
            case msg_personal_video:
            case msg_personal_file:
            case msg_personal_alert:
            default:
            {
                // 这些消息可能是同步自web
                // 自己发送的同步消息
                NSString *anotherName = [[MsgUserInfoMgr share] getUid];
                if ([baseModel._fromLoginName isEqualToString:anotherName])
                {
                    // 处理需要同步的消息
                    [self solveSynchMessage:baseModel];
                }
                else
                {
                    // 标记接收
                    [baseModel set_markFromReceive:YES];
                    [baseModel set_target:baseModel._fromLoginName];
                    
                    // 查找数据库过滤重复消息
                    BOOL isExsit = [[MsgSqlMgr share] queryMessageIsExsitWithBaseModel:baseModel];
                    if (isExsit)    // update
                    {
                        [self solveUpdateMessage:baseModel];
                    }
                    else
                    {
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
                            
                            [self solveCommonMessage:baseModel];
                        }
                        else if ([baseModel isEventType])
                        {
                            [self solveAppMessage:baseModel];
                        }
                    }
                }
            }
                break;
        }
    }
}

// 处理已读指令
- (void)solveReadType:(MessageBaseModel *)baseModel
{
    // 保存msgId
    [[MsgUserInfoMgr share] saveMaxMsgId:baseModel._msgId];
    long long msgId = [baseModel getMsgId];
    NSArray *arrMsgId = [NSArray arrayWithObject:[NSString stringWithFormat:@"%lld",msgId]];
    // 插入并更新数据库
    [[MsgSqlMgr share] markMessageReadedWithArrMsgId:arrMsgId];
}

// 处理clear指令
- (void)solveClearType:(MessageBaseModel *)baseModel
{
    // 保存msgId
    [[MsgUserInfoMgr share] saveMaxMsgId:baseModel._msgId];
   [self deleteMessageRecordsWithUid:baseModel._target];
}

// 处理open指令
- (void)solveOpenType:(MessageBaseModel *)baseModel
{
    // 保存msgId
    [[MsgUserInfoMgr share] saveMaxMsgId:baseModel._msgId];
    // 收到已打卡指令就清空改消息会话列表未读数
    [[MsgSqlMgr share] markMessageReadedWithUid:baseModel._target];
}

// 处理标记重点指令
- (void)solveMarkType:(MessageBaseModel *)baseModel Important:(BOOL)isImportant
{
    // 保存msgId
    [[MsgUserInfoMgr share] saveMaxMsgId:baseModel._msgId];
    if ([[MessageManager share] queryMessageIsImportantWithBaseModel:baseModel important:isImportant]) {
        // 如果 服务器同步的标记状态与本地数据库一致 , 就舍弃调此次同步
        return;
    }
    
    long long msgId = [baseModel getMsgId];
    [[MsgSqlMgr share] markMessageImportantWithMsgId:msgId important:isImportant];
}

/// 处理remove指令
- (void)solveRemoveType:(MessageBaseModel *)baseModel {
    [[MsgUserInfoMgr share] saveMaxMsgId:baseModel._msgId];
    [[MsgSqlMgr share] deleteMessageListWith:baseModel._target];
    
    if ([ContactDetailModel isGroupWithTarget:baseModel._target]) {
        [self.ignoreCacheRequestDictionary setObject:@1 forKey:GetGroupListRequest.class];
    }
}

// 处理撤回消息
- (void)solveResendMessage:(MessageBaseModel *)baseModel {
    [[MsgUserInfoMgr share] saveMaxMsgId:baseModel._msgId];
    [[MsgSqlMgr share] insertBatchData:@[baseModel] WithTag:table_msg];
        
    // 生成 联系人占位Model
    ContactDetailModel *contactModel = [[ContactDetailModel alloc] initWithMessageBaseModel:baseModel];
    // 查询是否有用户信息
    ContactDetailModel *oldModel = [[MsgSqlMgr share] querySessionDataWithUid:contactModel._target];
    if (!oldModel)
    {
        // 插入联系人表（去重、插入、修改逻辑数据库会完成）,返回信息完整度
        [[MsgSqlMgr share] writeMessageListInfoToContactTableWith:contactModel];
        [self getUserInfoWithUid:contactModel._target];
    }
    else
    {
        // 存在不更新nickName
        oldModel._countUnread = contactModel._countUnread;
        oldModel._timeStamp = contactModel._timeStamp;
        oldModel._info = contactModel._info;
        if ([baseModel getContentBaseModel]._msgId >= oldModel._lastMsgId)
        {
            oldModel._content = contactModel._content;
        }
        // 插入联系人表（去重、插入、修改逻辑数据库会完成）,返回信息完整度
        [[MsgSqlMgr share] writeMessageListInfoToContactTableWith:oldModel];
    }
    
    // 查询用户信息是否改变
    long long oldModified = [[MsgSqlMgr share] queryUserProfileModified:contactModel._target];
    if (baseModel._modified > oldModified)
    {
        [self getUserInfoWithUid:contactModel._target];
        // 更新头像
        [[NSNotificationCenter defaultCenter] postNotificationName:MTUserInfoChangeNotification object:contactModel._target];
    }
}

// 处理自己发送的同步消息
- (void)solveSynchMessage:(MessageBaseModel *)baseModel
{
    // 生成 联系人占位Model
    ContactDetailModel *contactModel = [[ContactDetailModel alloc] initWithMessageBaseModel:baseModel];

    // 插入或者更新数据库
    [[MsgSqlMgr share] insertBatchData:@[baseModel] WithTag:table_msg];
    
    // 保存msgId
    [[MsgUserInfoMgr share] saveMaxMsgId:baseModel._msgId];
    // 查询是否有用户信息
    ContactDetailModel *model = [[MsgSqlMgr share] querySessionDataWithUid:contactModel._target];
    if (!model) {
        // 插入联系人表（去重、插入、修改逻辑数据库会完成）,返回信息完整度
        [[MsgSqlMgr share] writeMessageListInfoToContactTableWith:contactModel];
        [self getUserInfoWithUid:contactModel._target];
        
    } else {
        // 只更新content
        model._content = contactModel._content;
        model._countUnread = contactModel._countUnread;
        model._lastMsgId = contactModel._lastMsgId;
        model._timeStamp = contactModel._timeStamp;
        model._info = contactModel._info;
        // 插入联系人表（去重、插入、修改逻辑数据库会完成）,只更新content
        [[MsgSqlMgr share] writeMessageListInfoToContactTableWith:model];
    }
}

// 处理更新消息
- (void)solveUpdateMessage:(MessageBaseModel *)baseModel
{
    if ([baseModel isEventType]) {
        [self solveAppMessage:baseModel];
    }
    else {
        [[MsgSqlMgr share] updateSendMessageSuccessWithBaseModel:baseModel];
    }
}

// 处理普通消息 语音文字图片等消息
- (void)solveCommonMessage:(MessageBaseModel *)baseModel
{
    // 生成 联系人占位Model
    ContactDetailModel *contactModel = [[ContactDetailModel alloc] initWithMessageBaseModel:baseModel];
    contactModel._lastMsg = baseModel.lastMsg;
    // 1.插入消息表
    [[MsgSqlMgr share] insertrBatchReceivedData:[NSArray arrayWithObject:baseModel] WithTag:table_msg];

    // 2.插入联系人表（去重、插入、修改逻辑数据库会完成）,返回信息完整度
    [[MsgSqlMgr share] writeMessageListInfoToContactTableWith:contactModel];
    
    // 保存msgId
    [[MsgUserInfoMgr share] saveMaxMsgId:baseModel._msgId];
    
    if ([contactModel isAtMe]) {
        [[MsgSqlMgr share] updateAtMeWithTarget:baseModel._target atMe:[contactModel isAtMe]];
    }
    
    // 查询用户信息是否改变
    long long oldModified = [[MsgSqlMgr share] queryUserProfileModified:contactModel._target];
    if (baseModel._modified > oldModified)
    {
        [self getUserInfoWithUid:contactModel._target];
        // 更新头像
        [[NSNotificationCenter defaultCenter] postNotificationName:MTUserInfoChangeNotification object:contactModel._target];
    }
}

// 处理应用消息
- (void)solveAppMessage:(MessageBaseModel *)baseModel
{
    // 保存msgId
    [[MsgUserInfoMgr share] saveMaxMsgId:baseModel._msgId];
    
    // 生成 联系人占位Model
    ContactDetailModel *contactModel = [[ContactDetailModel alloc] initWithMessageBaseModel:baseModel];
    contactModel._lastMsg = baseModel.lastMsg;
    // 存储app的信息
    contactModel._info = baseModel._content;
    // 1.插入消息表
    [[MsgSqlMgr share] insertBatchData:[NSArray arrayWithObject:baseModel] WithTag:table_msg];
    
    // 2.插入联系人表（去重、插入、修改逻辑数据库会完成）,返回信息完整度
    [[MsgSqlMgr share] writeMessageListInfoToContactTableWith:contactModel];
}

#pragma mark - DAL
// 获取服务器离线消息
- (void)getOfflineMessage
{
    [self.msgOfflineDAL getOfflineMessage];  // 获取成功之后获取离线消息
    
    // 标记所有正在发送的消息状态为失败
    [[MsgSqlMgr share] markMessageStatusSendingToFailed];
    
}

// 获取会话里历史消息
- (void)getHistoryMessageWithUid:(NSString *)uid MessageCount:(NSInteger)count
{
    if (count == 20) {
        self.getLocalHistory = NO;
        self.oldestTimeStamp = -1;
    }
    
    if (self.getLocalHistory) {
        if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_needRefreshWithTareget:)]) {
            [self.delegate MessageManagerDelegateCallBack_needRefreshWithTareget:uid];
        }
        
        return;
    }
    
    [self queryBatchMessageWithUid:uid MessageCount:count completion:^(NSArray *arrayData) {
//        MessageBaseModel *baseModel;
        
        // 切换设备第一次点击
        if (count == 20)
        {
            self.getLocalHistory = NO;
            self.oldestTimeStamp = -1;
//            baseModel = [arrayData lastObject];
            ContactDetailModel *detailModel = [[MsgSqlMgr share] querySessionDataWithUid:uid];
            if (detailModel)
            {
                // 第一次进入，获取消息
                GetHistoryMessageRequest *request = [GetHistoryMessageRequest new];
                request.strUid = uid;
                request.limit = 20;                 // 获取20条
                request.endTimestamp = -1;
                [request requestWithDelegate:self];
                return;
            }
        }
        
//        baseModel = [arrayData firstObject];
        GetHistoryMessageRequest *request = [GetHistoryMessageRequest new];
        request.strUid = uid;
        request.limit = 20;                         // 获取20条
        request.endTimestamp = self.oldestTimeStamp;
        [request requestWithDelegate:self];
    }];
}

- (void)getHistoryMessageWithUid:(NSString *)uid messageCount:(NSInteger)count endTimestamp:(long long)endTimestamp completion:(void (^)(NSArray *, BOOL))completion {
    
    NSParameterAssert(completion);
    
    if ([[SendMessageManager share].dictFirstHistoryRequest valueForKey:uid] && endTimestamp == -1) {
        completion(nil, YES);
    }
    
    [GetHistoryMessageBlockRequest sessionName:uid MessageCount:count endTimestamp:endTimestamp completion:^(IMBaseResponse *response, BOOL success) {
        if (!success) {
            completion(nil, NO);
            return;
        }
        
        if (endTimestamp == -1) {
            [[SendMessageManager share].dictFirstHistoryRequest setObject:@1 forKey:uid];
        }
        
        NSArray *messages = [(id)response arrMsgBaseModel];
        dispatch_async(self.messageQueue, ^{
            [[MsgSqlMgr share] insertrBatchReceivedData:messages WithTag:table_msg];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(messages, YES);
            });
        });
    }];
}

// 会话列表
- (void)getMessageList
{
    [self getNewMessageList];
    return;
}

/// 新版本unreadSession
- (void)getNewMessageList {
    [GetUnreadSessionBlockRequest getSessionCompletion:^(GetUnreadSessionResponse *response, BOOL success) {
       
        // 拉去历史请求缓存重置
        [[SendMessageManager share].dictFirstHistoryRequest removeAllObjects];
        
        if (!success) {
            [self openSocket];
            [[NSNotificationCenter defaultCenter] postNotificationName:MTBadgeCountChangedNotification object:nil];
            return;
        }
        
        if (response.maxMsgId > 0) {
            [[MsgUserInfoMgr share] saveMaxMsgId:response.maxMsgId];
        }
        
        [self openSocket];
        
        NSArray *appendContactModels = response.arrContactModel;
        NSArray *deleteContactTarget = response.deleteContactModel;
        
        dispatch_async(self.messageQueue, ^{
            for (NSString *sessionName in deleteContactTarget) {
                [[MsgSqlMgr share] deleteMessageListWith:sessionName];
            }
            
            for (ContactDetailModel *contactModel in appendContactModels) {
                // 查询是否有用户信息
                ContactDetailModel *model = [[MsgSqlMgr share] querySessionDataWithUid:contactModel._target];
                model._getFromUnReadList = YES;
                if (!model) {
                    // 插入联系人表（去重、插入、修改逻辑数据库会完成）,返回信息完整度
                    [[MsgSqlMgr share] writeMessageListInfoToContactTableWith:contactModel];
                } else {
                    // 只更新content
                    model._content     = contactModel._content;
                    model._countUnread = contactModel._countUnread;
                    model._lastMsgId   = contactModel._lastMsgId;
                    model._timeStamp   = contactModel._timeStamp;
                    model._nickName    = contactModel._nickName;
                    // 插入联系人表（去重、插入、修改逻辑数据库会完成）,只更新content
                    [[MsgSqlMgr share] writeMessageListInfoToContactTableWith:model];
                }
                
                [[MsgSqlMgr share] updateMuteNotificationWithModel:contactModel];
                
                // 查询用户信息是否改变
                UserProfileModel *oldProfile = [[MsgSqlMgr share] queryContactProfileWithUid:contactModel._target];
                if (contactModel._modified > oldProfile.modified && !contactModel._isGroup && !contactModel._isApp)
                {
                    // 更新头像头像
                    [[NSNotificationCenter defaultCenter] postNotificationName:MTUserInfoChangeNotification object:contactModel._target];
                }
                
                UserProfileModel *userProfile = [UserProfileModel new];
                userProfile.modified          = contactModel._modified == 0 ? oldProfile.modified : contactModel._modified;
                userProfile.nickName          = contactModel._nickName;
                userProfile.userName          = contactModel._target;
                userProfile.memberJasonString = oldProfile.memberJasonString;
                userProfile.avatar            = contactModel._headPic;
                userProfile.tag               = contactModel._tag;
                
                [[MsgSqlMgr share] updateContactInfoToContactTable:@[userProfile]];
                
                // memberJasonString 长度小于2时 没有成员
                if (contactModel._isGroup && [userProfile.memberJasonString length] <= 2) {
                    [self getUserInfoWithUid:contactModel._target];
                }
                else if (contactModel._modified > oldProfile.modified && !contactModel._isApp) {
                    [self getUserInfoWithUid:contactModel._target];
                }
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                
                // 发送刷新委托
                if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_needRefreshWithTareget:)]) {
                    [self.delegate MessageManagerDelegateCallBack_needRefreshWithTareget:nil];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:MTBadgeCountChangedNotification object:nil];
            });
        });
    }];
    
//    [[MsgSqlMgr share] markMessageStatusSendingToFailed];
}

// 开始下载附件
- (void)getAttachmentWithBaseModel:(MessageBaseModel *)model
{
    [self.attachmentDAL startDownloadFileWithBaseModel:model];
}


#pragma mark - SQL Manager
// 获取消息列表数据
- (void)getMessageListCompletion:(void (^)(NSArray<ContactDetailModel *> *))completion {
    [self getMessageListOnlyChat:NO completion:completion];
}

- (void)getMessageListOnlyChat:(BOOL)onlyChat completion:(void (^)(NSArray<ContactDetailModel *> *))completion {
    if (!completion) {
        return;
    }
    dispatch_async(self.messageQueue, ^{
        NSArray *arrMsgList = [[MsgSqlMgr share] queryMessageListDataOnlyChat:onlyChat];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(arrMsgList);
        });
    });
}

- (void)getMessageGroupListCompletion:(void (^)(NSArray *))completion {
    if (!completion) {
        return;
    }
    
    dispatch_async(self.messageQueue, ^{
        NSArray *groupList = [[MsgSqlMgr share] queryGroupList] ;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(groupList);
        });
    });
}

/**
 *  标记某个对象消息已读（发送已读成功后）
 *
 *  @param uid
 */
- (void)markMessageReadedWithUid:(NSString *)uid
{
    [[MsgSqlMgr share] markMessageReadedWithUid:uid];
    
    // 发送底部栏未读消息条数变化的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:MTBadgeCountChangedNotification object:nil];
}

- (void)sendReadedRequestWithUid:(NSString *)uid messages:(NSArray *)messages {
    SetMessageReadRequest *setReadRequest = [[SetMessageReadRequest alloc] initWithDelegate:self];
    [setReadRequest readedMessage:messages sessionName:uid];
}

- (void)markMessageReadedWithArrMsgId:(NSArray *)arrMsgId
{
    // array 有可能被更变
    NSArray * array = [NSArray arrayWithArray:arrMsgId];
    dispatch_async(self.messageQueue, ^{
        [[MsgSqlMgr share] markMessageReadedWithArrMsgId:array];
    });
}

- (void)markMessageListReadedWithUid:(NSString *)uid {
    dispatch_async(self.messageQueue, ^{
        [[MsgSqlMgr share] markMessageListReadedWithUid:uid];
    });
}

- (void)deleteMessageRecordsWithUid:(NSString *)uid
{
    [[MsgSqlMgr share] deleteMessageRecordsWith:uid];
    // 删除消息文件夹
    [[MsgFilePathMgr share] clearAllFileForMessageWithUid:uid];
}

- (void)deleteMessageListWithUid:(NSString *)uid
{
    [[MsgSqlMgr share] deleteMessageListWith:uid];
    // 删除消息文件夹
//    [[MsgFilePathMgr share] clearAllFileForMessageWithUid:uid];
}

- (void)loadGroupListFromCache:(BOOL)fromCache completion:(void (^)(NSArray<UserProfileModel *> *, BOOL))completion {
    GetGroupListRequest *request = [[GetGroupListRequest alloc] init];
    
    request.ignoreCache = !fromCache;
    if ([self.ignoreCacheRequestDictionary objectForKey:GetGroupListRequest.class]) {
        request.ignoreCache = NO;
    }
    
    [request requestDataCompletion:^(IMBaseResponse *response, BOOL success) {
        if (!success) {
            !completion ?: completion(nil, success);
            return;
        }
        
        self.ignoreCacheRequestDictionary[GetGroupListRequest.class] = nil;
        NSLog(@"----------->%ld",[(id)response groupList].count);
        !completion ?: completion([(id)response groupList], success);
    } isFromeCache:fromCache];
    
//    [request requestDataCompletion:^(IMBaseResponse *response, BOOL success){
//        if (!success) {
//            !completion ?: completion(nil, success);
//            return;
//        }
//        
//        self.ignoreCacheRequestDictionary[GetGroupListRequest.class] = nil;
//        NSLog(@"----------->%ld",[(id)response groupList].count);
//        !completion ?: completion([(id)response groupList], success);
//    }];
}

- (void)addRelationValidateToUser:(NSString *)toUserId
                           remark:(NSString *)remark
                          content:(NSString *)content
                  relationGroupId:(long)relationGroupId
                       completion:(void (^)(BOOL))completion
{
    if (relationGroupId == -1) {
        relationGroupId = [MsgUserInfoMgr share].defaultGroupId;
    }
    [AddRelationValidateRequest addRelationValidateRequestTo:toUserId
                                                      remark:remark
                                                     content:content
                                             relationGroupId:relationGroupId
                                                  completion:^(IMBaseResponse *response, BOOL success)
    {
        !completion ?: completion(success);
    }];
}



/**
 *  精确搜索 (用户名或者手机号)
 */
- (void)searchRelationUserWithRelationValue:(NSString *)relationValue completion:(void (^)(NSArray<MessageRelationInfoModel *> *, BOOL))completion
{
    [SearchRelationUserRequest searchRelationUserWithString:relationValue completion:^(IMBaseResponse *response, BOOL success) {
        if (success) {
            SearchRelationUserResponse * resp = (SearchRelationUserResponse *)response;
            !completion ?: completion(resp.dataArray,success);
        }
    }];
}

/**
 *  获取好友列表
 */
- (void)loadReLationGroupListcompletion:(void(^)(NSArray<MessageRelationGroupModel *> *array, BOOL success))completion
{
    [GetFriendInfolistRequest getFriendListRequestCompletion:^(IMBaseResponse *response, BOOL success) {
        if (!success) {
            completion(nil,success);
        }else
        {
            completion([(GetFriendInfolistResponse *)response dataArray],success);
        }
    }];
}


- (void)loadRelationGroupInfoWithTotalFlag:(BOOL)istotal Completion:(MTSuccessCompletion)completion
{
    
    void (^ loadRelationInfoRequest)() = ^{
        [LoadRelationGroupInfoRequest loadRelationGroupInfoWithMsgId:[[MsgUserInfoMgr share] loadRelationGroupInfoTimeInterval] isTotal:istotal Completion:^(IMBaseResponse *response, BOOL success)
         {
             if (!success) {
                 !completion ?: completion(success);
                 return;
             }
             
             LoadRelationGroupInfoResponse * resp = (LoadRelationGroupInfoResponse *)response;
             
             for (NSString *deleteRelationName in resp.remvoeRelations) {
                 [self deleteRelationInfoWithRelationName:deleteRelationName];
             }
             
             for (id deleteRelationGroup in resp.removeRelationGroups) {
                 [self deleteRelationGroupWithRelationGroupId:[deleteRelationGroup longValue]];
             }
             
             [self insertRelationInfoWithArray:resp.relations];
             [self insertRelationGroupWithArray:resp.relationGroups];
             
             !completion ?: completion(success);
         }];
    };
    
    
    long defaultGroupId = [MsgUserInfoMgr share].defaultGroupId;
    if (defaultGroupId == -1) {
        [RelationGroupInfoRequest RelationGroupInfoRequestWithCompletion:^(IMBaseResponse *response, BOOL success) {
            if (success) {
                [self insertRelationGroupWithArray:[(id)response dataArray]];
                for (MessageRelationGroupModel *model in [(id)response dataArray]) {
                    if (!model.isDefault) {
                        continue;
                    }
                    [[MsgUserInfoMgr share] setDefaultGroupId:model.relationGroupId];
                    break;
                }
                
                loadRelationInfoRequest();
            }
            else {
                !completion ?: completion(success);
            }
        }];
        
        return;
    }
    
    loadRelationInfoRequest();
}

- (void)loadServerRelationValidateListCompletion:(void (^)(NSArray<MessageRelationValidateModel *> *validlist , BOOL success))completion; {

    [RelationValidateListRequest validateListWithUserCompletion:^(IMBaseResponse *response, BOOL success) {
        if (!success) {
            !completion ?: completion(nil, success);
            return;
        }
        
        NSArray *array = [(id)response array];
        !completion ?: completion(array, success);
    }];
}

- (void)dealRelationWithModel:(MessageRelationValidateModel *)model
                validateState:(NSInteger)state
              relationGroupId:(long)relationGroupId
                       remark:(NSString *)remark
                      content:(NSString *)content
                   completion:(MTSuccessCompletion)completion
{
    if (relationGroupId == -1) {
        relationGroupId = [MsgUserInfoMgr share].defaultGroupId;
    }
    [DisposeRelationValidateRequest dealRelationWithModel:model validateState:state relationGroupId:relationGroupId remark:remark content:content completion:^(IMBaseResponse *response, BOOL success) {
        !completion ?: completion(success);
    }];
}

- (void)deleteRelationWithUid:(NSString *)uid completion:(MTSuccessCompletion)completion
{
    [DeleteRelationRequest deleteRelationWithUid:uid completion:^(BOOL isSuccess) {
        if (isSuccess) [[MessageManager share] deleteRelationInfoWithRelationName:uid];
        
        if (completion) {
            completion(isSuccess);
            
        }
    }];
}

- (void)deleteRelationGroupWithRelationGroupId:(long)relationGroupId completion:(MTSuccessCompletion)completion
{
    [DeleteRelationGroupRequest deleteRelationWithGroupId:[NSString stringWithFormat:@"%ld",relationGroupId] completion:^(BOOL isSuccess) {
        if (isSuccess)
        {
            [[MessageManager share] deleteRelationGroupWithRelationGroupId:relationGroupId];
        }
        if (completion)
        {
            completion(isSuccess);
        }
    }];
}

- (void)remarkRelationWithUid:(NSString *)relationName remark:(NSString *)remark completion:(MTSuccessCompletion)completion
{
    [RemarkRelationRequest remarkRelationWithUid:relationName remark:remark completion:^(BOOL isSuccess) {
        if (completion) {
            completion(isSuccess);
        }
    }];
}

- (void)createRelationGroupWithName:(NSString *)groupName completion:(void (^)(MessageRelationGroupModel *, BOOL))completion
{
    [CreateRelationGroupRequest createGroupName:groupName completion:^(IMBaseResponse *response, BOOL success) {
        if (!success) {
            !completion ?: completion(nil , NO);
            return;
        }
        
        MessageRelationGroupModel *model = [(id)response groupModel];
//model 实际没有数据
//        [self insertRelationGroupWithArray:@[model]];
        
        !completion ?: completion(model, success);
    }];
}

- (void)modifyRelationGroupInfoGroupModel:(MessageRelationGroupModel *)groupmodel comletion:(MTSuccessCompletion)completion
{
    [modifyRelationGroupRequest modifyRelationGroupWithGroupId:groupmodel.relationGroupId relationName:groupmodel.relationGroupName completion:^(BOOL isSuccess) {
        if (isSuccess)
        {
            [self updateRelationGroup:groupmodel];
        }
        if (completion)
        {
            completion(isSuccess);
        }
    }];
}

//移动好友分组
- (void)transferRelationWithRelationName:(NSString *)relationName
                         RelationGroupID:(NSNumber *)relationGroupID
                              completion:(void(^)(BOOL isSuccess))completion
{
        [FriendsTransferRelationRequest transferRelationWithRelationName:relationName relationGroupID:relationGroupID completion:^(BOOL isSuccess) {
            completion(isSuccess);
        }];
}

// ************** 好友SQL **************//
#pragma mark - 好友SQL
/**
 *  批量插入好友分组
 *
 *   @param array
 */
- (void)insertRelationGroupWithArray:(NSArray <MessageRelationGroupModel *>*)array
{
    [[MsgSqlMgr share] insertRelationGroupWithArray:array];
}
/**
 * 批量插入好友信息
 *
 *  @param array
 */
- (void)insertRelationInfoWithArray:(NSArray <MessageRelationInfoModel *>*)array
{
    [[MsgSqlMgr share] insertRelationInfoWithArray:array];
}
/**
 * 删除好友分组
 *
 * @param  relationGroupId 好友分组id
 */
- (void)deleteRelationGroupWithRelationGroupId:(long)relationGroupId
{
    
    [[MsgSqlMgr share] deleteRelationGroupWithRelationGroupId:relationGroupId];
}
/**
 *  删除好友
 *
 *  @param  relationName 好友用户名
 */
- (void)deleteRelationInfoWithRelationName:(NSString *)relationName
{
    [[MsgSqlMgr share] deleteRelationInfoWithRelationName:relationName];
}
/**
 *  修改好友分组
 *
 *  @param relationGroup  MessageRelationGroupModel
 */
- (void)updateRelationGroup:(MessageRelationGroupModel *)relationGroup
{
    [[MsgSqlMgr share] updateRelationGroup:relationGroup];
}
/**
 *  修改好友信息
 *
 *  @param  relationInfo 好友MessageRelationInfoModel名
 */
- (void)updateRelationInfo:(MessageRelationInfoModel *)relationInfo
{
    [[MsgSqlMgr share] updateRelationInfo:relationInfo];
}
/**
 *  获取所有好友分组
 *
 *  @return  @[MessageRelationGroupModel_objs]
 */
- (NSArray *)queryRelationGroups
{
    return  [[MsgSqlMgr share] queryRelationGroups];
}
/**
 *  获取某分组下的所有好友
 *
 *  @param  relationGroupId 好友分组id
 *  @return  @[MessageRelationInfoModel_objs]
 */
- (NSArray *)queryRelationInfoWithRelationGroup:(long)relationGroupId
{
    return [[MsgSqlMgr share] queryRelationInfoWithRelationGroup:relationGroupId];
}

/**
 *  获取分组下是否有这个好友
 *
 *  @param relationGroupId 好友分组ID
 *  @param userId          好友用户名
 *
 */
- (BOOL )queryRelationInfoWithRelationGroup:(long)relationGroupId userID:(NSString *)userId
{
    return [[MsgSqlMgr share] queryRelationInfoWithRelationGroup:relationGroupId relationName:userId];
}

/**
 *  获取对应id的用户
 *
 *  @param userId userShowID
 *
 *  @return 数组，为了不让这个类接触到其他model
 */
- (MessageRelationInfoModel *)queryRelationInfoWithUserID:(NSString *)userId
{
    return [[MsgSqlMgr share] queryRelationInfoWithRelationName:userId];
}

- (NSArray *)queryRelationInfoWithNickName:(NSString *)nickName remark:(NSString *)remark
{
    return [[MsgSqlMgr share] queryRelationInfoWithName:nickName remark:remark];
}

#pragma mark  好友SQL
#pragma mark -
// ************** 好友SQL **************//


- (void)queryBatchMessageWithUid:(NSString *)uid MessageCount:(NSInteger)count completion:(void (^)(NSArray<MessageBaseModel *> *))completion
{
    if (!completion) {
        return;
    }
    
    dispatch_async(self.messageQueue, ^{
       NSArray *array = [[MsgSqlMgr share] queryBatchMessageWithAnotherName:uid MessageCount:count];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(array);
        });
    });
}

- (NSArray *)queryBatchImageMessageWithUid:(NSString *)uid
{
    return [[MsgSqlMgr share] queryAllImageMessageFromUid:uid];
}

- (void)queryAllUnreadMessageCountCompletion:(void (^)(NSInteger))completion {
    if (!completion) {
        return;
    }
    
    dispatch_async(self.messageQueue, ^{
        NSInteger unreadCount = [[MsgSqlMgr share] queryAllUnreadMessageCount];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(unreadCount);
        });
    });
}

- (void)queryUnreadMessageCountWithoutUid:(NSString *)uid completion:(void (^)(NSInteger))completion {
    if (!completion) {
        return;
    }
    
    dispatch_async(self.messageQueue, ^{
        NSInteger unreadCount = [[MsgSqlMgr share] queryUnreadMessageCountWithoutUid:uid];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(unreadCount);
        });
    });
}


/**
 *  查询某个对象的会话
 *
 *  @param uid 对象标识符
 */
- (void)querySessionDataWithUid:(NSString *)uid completion:(void (^)(ContactDetailModel *))completion {
    if (!completion) {
        return;
    }
    
    dispatch_async(self.messageQueue, ^{
        ContactDetailModel *model = [[MsgSqlMgr share] querySessionDataWithUid:uid];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(model);
        });
    });
}

/**
 *  查询一个联系人/群的信息
 *
 *  @param uid 联系人唯一标识符
 *
 *  @return 用户信息
 */
- (UserProfileModel *)queryContactProfileWithUid:(NSString *)uid {
    return [[MsgSqlMgr share] queryContactProfileWithUid:uid];
}

/**
 *  查询一个联系人的信息
 *
 *  @param nickName 联系人昵称
 *
 *  @return 用户信息
 */
- (UserProfileModel *)queryContactProfileWithNickName:(NSString *)nickName
{
    return [[MsgSqlMgr share] queryContactProfileWithNickName:nickName];
}

/**
 *  全局搜索的数据查询
 *
 *  @param keyword 关键词
 *
 *  @return 搜索结果
 */
- (NSArray *)querySearchMessageListWithKeyword:(NSString *)keyword {
    return [[MsgSqlMgr share] querySearchMessageListWithKeyword:keyword];
}

/**
 *  查询一个联系人/群的所有未读信息
 *
 *  @param uid 联系人唯一标识符 msgId 唯一标识符
 *
 *  @return 用户信息msgId数组(NSString)格式 取出大于该msgId的未读消息
 */
- (void)getAllUnReadedMessageListWithUid:(NSString *)uid msgId:(long long)msgId completion:(void (^)(NSArray *))completion
{
    if (!completion) {
        return;
    }
    dispatch_async(self.messageQueue, ^{
       NSArray *array = [[MsgSqlMgr share] queryAllUnReadedMessageListWithUid:uid msgId:msgId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(array);
        });
    });
}

- (void)updateDraftWithTarget:(NSString *)target draft:(NSAttributedString *)draft {
    NSAttributedString *draftTmp = [draft copy];
    dispatch_async(self.messageQueue, ^{
        [[MsgSqlMgr share] updateDraftWithTarget:target draft:draftTmp];
    });
}

- (void)updateAtMeWithTarget:(NSString *)target atMe:(BOOL)atMe {
    dispatch_async(self.messageQueue, ^{
        [[MsgSqlMgr share] updateAtMeWithTarget:target atMe:atMe];
    });
}

/**
 *  单个聊天信息搜索
 *
 *  @param keyword 关键词
 *  @param uid     对象
 *
 *  @return 搜索结果
 */
- (NSArray *)querySearchMessageListWithKeyword:(NSString *)keyword uid:(NSString *)uid {
    return [[MsgSqlMgr share] querySearchMessageListWithKeyword:keyword uid:uid];
    
}

/**
 *  标记重点
 *
 *  @param baseModel   要标记的model
 *  @param isImportant 是否重点
 */
- (void)markMessageImportantWithModel:(MessageBaseModel *)baseModel important:(BOOL)isImportant {
    [[MsgSqlMgr share] markMessageImportantWithMsgId:baseModel._msgId important:isImportant];
}
/**
 *  从某一条信息开始查找之前的历史，包含这条数据
 *
 *  @param sqlID key消息
 *  @param count 查询的条数
 *  @param uid   用户唯一标识符
 *  @return 查询到的数据数组
 */
- (NSArray *)queryOlderMessageHistoryFromSqlID:(long long)sqlID count:(NSInteger)count uid:(NSString *)uid {
    return [[MsgSqlMgr share] queryOlderMessageHistoryFromSqlID:sqlID count:count uid:uid];
}

/**
 *  从某一条信息开始查找之后的历史，包含这条数据
 *
 *  @param sqlID key消息
 *  @param count 查询的条数
 *  @param uid   用户唯一标识符
 *  @return 查询到的数据数组
 */
- (NSArray *)queryNewerMessageHistoryFromSqlID:(long long)sqlID count:(NSInteger)count uid:(NSString *)uid {
    return [[MsgSqlMgr share] queryNewerMessageHistoryFromSqlID:sqlID count:count uid:uid];
}
/**
 *  从某一条信息开始查找之后的历史，包含这条数据  --> Event
 *
 *  @param sqlID key消息
 *  @param count 查询的条数
 *  @param uid   用户唯一标识符
 *  @return 查询到的数据数组
 */
- (NSArray *)queryNewerEventMessageHistoryFromCreatDate:(long long)creatDate count:(NSInteger)count uid:(NSString *)uid
{
    return [[MsgSqlMgr share] queryNewerEventMessageHistoryFromCreatDate:creatDate count:count uid:uid];
}
/**
 *  从某一条信息开始查找之前的历史，包含这条数据  --> Event
 *
 *  @param sqlID key消息
 *  @param count 查询的条数
 *  @param uid   用户唯一标识符
 *  @return 查询到的数据数组
 */
- (NSArray *)queryOlderEvevtMessageHistoryFromCreatDate:(long long)creatDate count:(NSInteger)count uid:(NSString *)uid
{
    return [[MsgSqlMgr share] queryOlderEvevtMessageHistoryFromCreatDate:creatDate count:count uid:uid];
}

/**
 *  单个聊天信息查询 --> @我的消息
 *
 *  @param target     聊天ID
 *
 *  @return 查询结果
 */
- (NSArray *)queryAtMeMessageFromTarget:(NSString *)target {
    return [[MsgSqlMgr share] queryAtMeMessageFromTarget:target];
}

/**
 *  单个聊天信息查询 --> 图片 OR 文件
 *
 *  @param target     聊天ID
 *
 *  @return 查询结果
 */
- (NSArray *)queryImportantImageMessageFromTarget:(NSString *)target msg_type:(Msg_type)type
{
    return [[MsgSqlMgr share] queryImportantImageMessageFromTarget:target msg_type:type];
}
/**
 *  单个聊天信息查询 --> 被标记为重点
 *
 *  @param target     聊天ID
 *
 *  @return 查询结果
 */
- (NSArray *)queryImportantFileAndTextMessageFromTarget:(NSString *)target
{
    return [[MsgSqlMgr share] queryImportantFileAndTextMessageFromTarget:target];
}
/**
 *  单个聊天信息查询 --> 应用
 *
 *  @param target     聊天ID
 *
 *  @return 查询结果
 */
- (NSArray *)queryAppMessageWithTarget:(NSString *)target
{
    return [[MsgSqlMgr share] queryAppMessageWithTarget:target];
}

/**
 *  查询消息表里 的某条消息是否与服务器同步的状态一致 (标记重点状态)
 */
- (BOOL)queryMessageIsImportantWithBaseModel:(MessageBaseModel *)baseModel important:(BOOL)isImportant
{
    MessageBaseModel * model = [[MessageBaseModel alloc] init];
    model._clientMsgId = [baseModel getMsgId];
    model._markImportant = isImportant;
    return [[MsgSqlMgr share] queryMessageIsImportantWithBaseModel:model];
}
/**
 *  查询某个人是否是某群的群成员
 */
- (BOOL)queryPeopleIsGroupMembersWithGroupUserName:(NSString *)userName Show_ID:(NSString *)Show_ID{
    return [[MsgSqlMgr share] queryPeopleIsGroupMembersWithGroupUserName:userName Show_ID:Show_ID];
}
/*
 * 查询某个会话中 ,缓存中的最新的消息是不是数据库中最新的
 * @param tager 会话唯一标示符 ,会话名称
 * @param 最新消息的msgid
 *
 */
- (BOOL)queryMessageIsNewestWithTagert:(NSString *)tagert msgid:(long long)msgid
{
    dispatch_async(dispatch_get_main_queue(), ^{
    
    });
    return [[MsgSqlMgr share] queryMessageIsNewestWithTagert:tagert msgid:msgid];
}

#pragma mark - Send Message
// 发送消息
- (void)sendMessageTo:(NSString *)to nick:(NSString *)nick WithContent:(id)content Type:(Msg_type)msgType {
    [self sendMessageTo:to nick:nick WithContent:content Type:msgType atUser:nil];
}

- (void)sendMessageTo:(NSString *)to nick:(NSString *)nick WithContent:(id)content Type:(Msg_type)msgType atUser:(NSArray *)atUserList {
    [[ChatMsgManager share] sendMessageTo:to NickName:nick WithContent:content Type:msgType atUserList:atUserList];
}

- (MessageBaseModel *)anchorAttachMessageType:(Msg_type)type toTarget:(NSString *)toTarget nickName:(NSString *)nickName primaryPath:(NSString *)primaryPath minorPath:(NSString *)minorPath {
    
    AttachmentType attachType = attachment_image;
    switch (type) {
        case msg_personal_image:
            attachType = attachment_image;
            break;
        case msg_personal_voice:
            attachType = attachment_audio;
            break;
        case msg_personal_video:
            attachType = attachment_video;
            break;
        default:
            NSAssert(false, @"不知名类型，请使用image、voice、video");
            break;
    }
    
    MessageBaseModel *model = [[ChatMsgManager share] anchorAttachMessageType:type toTarget:toTarget nickName:nickName primaryPath:primaryPath minorPath:minorPath];
    
    // 原始文件路径
    __block NSString *fullPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:primaryPath];
    
    // 若为语音，需要在分线程wav转amr成功后再进行上传
    void (^completion)() = ^{
        // fullPath为转换后的amr路径
        AttachmentUploadModel *uploadModel = [[AttachmentUploadModel alloc] initWithPath:fullPath type:attachType];
        
        IMAttachmentUploadRequest *attachUploadRequest = [[IMAttachmentUploadRequest alloc] init];
        [attachUploadRequest uploadWithAttach:uploadModel];
        attachUploadRequest.baseModel = model;
        
        [[IMUploadFileSessionManager share] addRequest:attachUploadRequest];
    };
    
    if (attachType == attachment_audio) {
        // 语音用amr上传 转换原始路径为amr路径
        fullPath = [AudioMessageManager wavToAmr:fullPath
                                            queue:dispatch_queue_create("IM.wavToamr", DISPATCH_QUEUE_SERIAL)
                                        completion:^{
                                            completion();
                                        }];

        minorPath = [[MsgFilePathMgr share] getRelativePathWithAllPath:fullPath];
        model._nativeThumbnailUrl = minorPath;

        return model;
    }
    
    completion();
    return model;
}

/**
 *  发送用户信息更改的消息
 *
 *  @param modified 更改后的modified
 */
- (void)sendUserModifiedWithModified:(long long)modified
{
    [[ChatMsgManager share] sendUserModified:modified];
}

/**
 *  从服务器下载语音资源  成功后通过委托回调刷新(刷新该条语音)
 *
 *  @param baseModel MessageBaseModel
 */
- (void)downloadAudioSourceWithModel:(MessageBaseModel *)baseModel
{
    [self.audioDownloadManager addTaskWithModel:baseModel];
}

/**
 *  上传图片，语音失败情况下标记为发送失败
 *
 */
- (void)markUploadingMessageToFaild:(MessageBaseModel *)baseModel
{
    // 标记为失败
    [[MsgSqlMgr share] markMessageStatusWaitingToFailed:baseModel];
    
    // 发送刷新委托
    if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_needRefreshWithTareget:)])
    {
        [self.delegate MessageManagerDelegateCallBack_needRefreshWithTareget:baseModel._target];
    }
    
}


- (void)shouldReSendMessageWith:(MessageBaseModel *)baseModel
{
    // 清除数据
    [[MsgSqlMgr share] deleteMessageWithModel:baseModel];

    // 发送刷新委托
    if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_deleteMessage:)])
    {
        [self.delegate MessageManagerDelegateCallBack_deleteMessage:baseModel];
    }
}

/**
 *  创建群组成功保存群组信息
 *
 */
- (void)saveGroupModel:(UserProfileModel *)model
{
    // 群组信息写入表中
    [[MsgSqlMgr share] updateContactInfoToContactTable:@[model]];
}

- (void)updateMuteNotification:(ContactDetailModel *)model {
    [[MsgSqlMgr share] updateMuteNotificationWithModel:model];
}

#pragma mark - IMUploadFileSessionMananger Delegate
- (void)IMUploadFileSessionManagerDelegateCallBack_finishWithAttachModel:(AttachmentUploadModel *)model uploadMesageModel:(MessageBaseModel *)uploadBaseModle progress:(double)progress {
    if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_uploadModel:progress:failedReason:)]) {
        [self.delegate MessageManagerDelegateCallBack_uploadModel:uploadBaseModle progress:progress failedReason:nil];
    }
}

- (void)IMUploadFileSessionManagerDelegateCallBack_uploadFailedReason:(NSString *)reason uploadMesageModel:(MessageBaseModel *)uploadBaseModel {
    if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_uploadModel:progress:failedReason:)]) {
        [self.delegate MessageManagerDelegateCallBack_uploadModel:uploadBaseModel progress:0 failedReason:reason];
    }
}

#pragma mark - MessageOfflineDAL Delegate
// 离线消息请求的委托回调
- (void)MessageOfflineDALDelegateCallBack_FinishWith:(id)objTarget
{
    self.msgOfflineDAL = (MessageOfflineDAL *)objTarget;
    // 数据写入
    if (self.msgOfflineDAL._arrMsg.count)
    {
        // 批量解析消息
//        [[ChatMsgManager share] parseOffLineMessages:self.msgOfflineDAL._arrMsg];
        NSArray *messageArray = [NSArray arrayWithArray:self.msgOfflineDAL._arrMsg];
        dispatch_async(self.offlineQueue, ^{
            // 批量解析消息 不刷新 只插入数据库
            [self parseOfflineMessages:messageArray];
            
            if (!self.msgOfflineDAL._remain) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            }
        });
        
    }
    
    if (self.msgOfflineDAL._remain)
    {
        // 获取下一波数据
        [self.msgOfflineDAL getOfflineMessage];
        return;
    }

    dispatch_async(self.offlineQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // 刷新UI 一次就够了
            if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_needRefreshWithOfflineMessage)])
            {
                [self.delegate MessageManagerDelegateCallBack_needRefreshWithOfflineMessage];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:MTBadgeCountChangedNotification object:nil];
            
            // openSocket
            [self openSocket];
        });
    });
}

// 离线消息请求失败的委托回调
- (void)MessageOfflineDALDelegateCallBack_FailWith:(id)objTarget
{
    // 销毁离线消息请求器
    [_msgOfflineDAL setDelegateMsgOffline:nil];
    _msgOfflineDAL = nil;
    
    // openSocket
    [self openSocket];
}

#pragma mark - IMBaseRequest Delegate
- (void)requestSucceed:(IMBaseRequest *)request withResponse:(IMBaseResponse *)response {
    if ([request isKindOfClass:[GetHistoryMessageRequest class]])
    {
        // 存储最大msgId
        NSArray *messageList = [(id)response arrMsgBaseModel];
        [[MsgSqlMgr share] insertBatchData:messageList WithTag:table_msg];
        MessageBaseModel *latestMessage = [messageList lastObject];
        [[MsgUserInfoMgr share] saveMaxMsgId:latestMessage._msgId];
        
        MessageBaseModel *oldestMessage = [messageList firstObject];
        if (oldestMessage) {
            self.oldestTimeStamp = oldestMessage._msgId;
        }
        
        // 发送刷新委托
        if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_needRefreshWithTareget:)])
        {
            [self.delegate MessageManagerDelegateCallBack_needRefreshWithTareget:[(id)request strUid]];
        }
    }
    
    else if ([request isKindOfClass:[SetMessageReadRequest class]]) {
        [self markMessageReadedWithArrMsgId:[(id)response readedMessages]];
        [self markMessageListReadedWithUid:[(id)response sessionName]];
    }
}

- (void)requestFail:(IMBaseRequest *)request withResponse:(IMBaseResponse *)response {
    
    if ([request isKindOfClass:[GetHistoryMessageRequest class]])
    {
        // 发送刷新委托
        if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_needRefreshWithTareget:)])
        {
            self.getLocalHistory = YES;
            [self.delegate MessageManagerDelegateCallBack_needRefreshWithTareget:[(id)request strUid]];
        }
    }
}

#pragma mark - SocketManager Delegate
// 收到服务器的消息委托
- (void)SocketManagerCallBack_didReceiveMessage:(id)message
{
    // 让聊天处理器去解析消息
    [[ChatMsgManager share] parseReceiveMessage:message];
}

// 握手成功
- (void)SocketManagerCallBack_webSocketDidOpen
{
    // 先登录，开始轮询心跳30一次
    [self socketLogin];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MTSocketConnectSuccessedNotification object:nil];
}

// 握手失败
- (void)SocketManagerCallBack_webSocketDidFailed
{
    // 重新连接
    if ([UnifiedNetworkManager getNetworkCurrentStatus])
    {
        // 网络连接连接上,进入轮询login模式
        // 重新连接socket
        if ([MsgUserInfoMgr share]._isLoginIn)
        {
            // 重连socket 先获取会话列表
            [self getMessageList];
            
//            [self openSocket];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:MTSocketConnectingNotification object:nil];
        }
    }
    else
    {
        // 网络未连接上，暂停一切事务，网络连接上的委托回调中重新开启新的webSocket
        [[NSNotificationCenter defaultCenter] postNotificationName:MTSocketConnectFailedNotification object:nil];
    }
}

#pragma mark - ChatMsgManager Delegate
// 发送WebSocket操作消息处理打包的委托回调
- (void)ChatMsgManagerDelegateCallBack_sendMessageForConnection:(NSString *)message
{
    // 发送webSocket
    NSDictionary *dict = [message mt_im_objectFromJSONString];
    NSString *type = [dict valueForKey:@"type"];
    if ([type isEqualToString:@"LoginKeep"]) {
        // loginkeep
        [[SocketManager share] sendPing:message];
    } else {
        // login信息
        [[SocketManager share] sendMessage:message];
    }
    
}

// 发送（文本、语音、任务消息）消息处理打包的委托回调
- (void)ChatMsgManagerDelegateCallBack_sendMessage:(NSString *)message ContactModel:(ContactDetailModel *)contactModel BaseModel:(MessageBaseModel *)baseModel
{
    // 只在发送的时候置为event
    if (baseModel._type == msg_personal_event)
    {
        baseModel._type = baseModel.appModel.eventType;
    }
    
    // 1.写入消息列表
    [[MsgSqlMgr share] insertBatchData:[NSArray arrayWithObject:baseModel] WithTag:table_msg];
    
    // 2.写入联系人列表
    [[MsgSqlMgr share] writeMessageListInfoToContactTableWith:contactModel];
    
    
    [[SendMessageManager share] sendMessage:baseModel socketString:message];
    
    if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_needRefreshWithMessageBaseModel:)]) {
        [self.delegate MessageManagerDelegateCallBack_needRefreshWithMessageBaseModel:baseModel];
    }
}

// 发送个人信息更改消息
- (void)ChatMsgManagerDelegateCallBack_sendUserModified:(NSString *)message
{
    // 发送webSocket
    [[SocketManager share] sendMessage:message];
}

// 收到消息的委托回调
- (void)ChatMsgManagerDelegateCallBack_receiveMessageWithMessageModel:(MessageBaseModel *)msgModel
{
    ContactDetailModel *contactModel = [[ContactDetailModel alloc] initWithMessageBaseModel:msgModel];
    if (contactModel.isRelationSystem) {
        [self loadRelationGroupInfoWithTotalFlag:NO Completion:nil];
    }
    
    dispatch_async(self.messageQueue, ^{
        if ([msgModel isEventType]) {
            [self solveAppMessage:msgModel];
        } else {
            [self solveCommonMessage:msgModel];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 发送刷新委托
            if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_receiveMessage:)]) {
                // 聊天界面下，直接插入消息
                [self.delegate MessageManagerDelegateCallBack_receiveMessage:msgModel];
            }
            else if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_needRefreshWithTareget:)])
            {
                [self.delegate MessageManagerDelegateCallBack_needRefreshWithTareget:msgModel._target];
            }
            
            // 新消息提醒
            if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_PlaySystemKind)]) {
                [self.delegate MessageManagerDelegateCallBack_PlaySystemKind];
            }
            // 发送底部栏未读消息条数变化的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:MTBadgeCountChangedNotification object:nil];
        });
    });
}

// msgReceiveSelf,收到自己发送的同步消息
- (void)ChatMsgManagerDelegateCallBack_receiveMessageSynch:(MessageBaseModel *)baseModel
{
    dispatch_async(self.messageQueue, ^{
        [self solveSynchMessage:baseModel];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 发送刷新委托
            if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_receiveMessage:)])
            {
                [self.delegate MessageManagerDelegateCallBack_receiveMessage:baseModel];
            }
            else if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_needRefreshWithTareget:)]) {
                [self.delegate MessageManagerDelegateCallBack_needRefreshWithTareget:baseModel._target];
            }
        });
    });
}


/** 收到数据更新的委托
 */
- (void)ChatMsgManagerDelegateCallBack_receiveUpdateMessageWithMessageModel:(MessageBaseModel *)baseModel
{
    ContactDetailModel *contactModel = [[ContactDetailModel alloc] initWithMessageBaseModel:baseModel];
    if (contactModel.isRelationSystem) {
        [self loadRelationGroupInfoWithTotalFlag:NO Completion:nil];
    }
    
    dispatch_async(self.messageQueue, ^{
        [self solveUpdateMessage:baseModel];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 2、更新联系人列表占位 (更新处理说明此条消息是重复的 不需要写入)
            //    [[MsgSqlMgr share] writeMessageListInfoToContactTableWith:contactModel];
            
            // 2、发送委托刷新显示
            if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_needRefreshWithTareget:)])
            {
                [self.delegate MessageManagerDelegateCallBack_needRefreshWithTareget:baseModel._target];
            }
        });
    });
}

// 收到服务器回执的委托回调
- (void)ChatMsgManagerDelegateCallBack_receiveFinishSendWithBaseModel:(MessageBaseModel *)baseModel
{
    // 保存msgID
    [[MsgUserInfoMgr share] saveMaxMsgId:baseModel._msgId];
    
    // 1.更改发送状态列表
    NSString *strTarget = [[MsgSqlMgr share] updateMessageStatusWithBaseModel:baseModel Status:status_send_success];
    
    // 查询是否有用户信息
    ContactDetailModel *model = [[MsgSqlMgr share] querySessionDataWithUid:strTarget];
    if (model && baseModel._markStatus == status_send_success)
    {        
        model._timeStamp = baseModel._createDate;
        // 插入联系人表（去重、插入、修改逻辑数据库会完成）,只更新时间
        [[MsgSqlMgr share] writeMessageListInfoToContactTableWith:model];
        
        if ([model._nickName length] == 0) {
            [self getUserInfoWithUid:strTarget];
        }
        
    }
    
    // 2.结束定时器
    [[MessageTimerManager share] removeTimerWithCid:baseModel._clientMsgId];
    
    // 3.结束心跳超时检测器
    [[MessageTimerManager share] stopLoginTimer];
    
    // 4.收到回执发送消息队列里的下一条消息
    [[SendMessageManager share] sendMessageSuccess];
    
    // 5.刷新显示列表
    if (strTarget != nil)
    {
        if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_synchMessage:)]) {
            [self.delegate MessageManagerDelegateCallBack_synchMessage:baseModel];
        }
        else if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_needRefreshWithTareget:)])
        {
            [self.delegate MessageManagerDelegateCallBack_needRefreshWithTareget:strTarget];
        }
    }
}

// wsLoginIn
- (void)ChatMsgManagerDelegateCallBack_wsLoginIn
{
    // 结束login循环
    if (_timerLogin != nil)
    {
        [_timerLogin invalidate];
    }
    
    // 结束超时检测器
    [[MessageTimerManager share] stopLoginTimer];
    [[MessageTimerManager share] removeAllTimers];
    
    // 开始心跳
    [self loginKeep];
    
    self.socketLogin = YES;
    
    // 重连发送
    [[SendMessageManager share] reStart];
}

// wsLoginOut
- (void)ChatMsgManagerDelegateCallBack_wsLoginOutWithContent:(NSString *)content
{
    // 结束超时检测器
    [[MessageTimerManager share] stopLoginTimer];
    [[MessageTimerManager share] stopLoginKeepTimer];
    [[MessageTimerManager share] removeAllTimers];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MTLogoutNotification object:content];
    [[NSNotificationCenter defaultCenter] postNotificationName:MTWebsocketLogoutNotification object:nil];
}

// wsLoginKeep
- (void)ChatMsgManagerDelegateCallBack_receiveLoginKeepSuccess
{
    // 1.结束心跳超时检测器
    [[MessageTimerManager share] stopLoginKeepTimer];
}

/** 收到已读消息的委托
 */
- (void)ChatMsgManagerDelegateCallBack_receiveReadedMessages:(MessageBaseModel *)baseModel
{
    dispatch_async(self.messageQueue, ^{
        [self solveReadType:baseModel];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_markReadedMessage:)]) {
                [self.delegate MessageManagerDelegateCallBack_markReadedMessage:baseModel];
            }
            else if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_needRefreshWithTareget:)])
            {
                [self.delegate MessageManagerDelegateCallBack_needRefreshWithTareget:baseModel._target];
            }
        });
    });
}
/**
 *  收到清空指令的委托
 *
 */
- (void)ChatMsgManagerDelegateCallBack_receiveClearMessages:(MessageBaseModel *)baseModel {
    [self solveClearType:baseModel];
}

/** 收到已打开会话列表的委托 清空列表消息红点
 */
- (void)ChatMsgManagerDelegateCallBack_receiveOpenMessages:(MessageBaseModel *)baseModel
{
    dispatch_async(self.messageQueue, ^{
        // 收到已打卡指令就清空改消息会话列表未读数
        [self solveOpenType:baseModel];
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            // 发送刷新委托
            if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_clearUnreadWithTarget:)]) {
                [self.delegate MessageManagerDelegateCallBack_clearUnreadWithTarget:baseModel._target];
            }
            
            // 发送底部栏未读消息条数变化的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:MTBadgeCountChangedNotification object:nil];
        });
    });
}

/** 收到已标重点的委托
 */
- (void)ChatMsgManagerDelegateCallBack_receiveMarkedMessages:(MessageBaseModel *)baseModel important:(BOOL)isImportant
{
    [self solveMarkType:baseModel Important:isImportant];
    
    // 发送刷新委托
    if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_needRefreshWithTareget:)])
    {
        [self.delegate MessageManagerDelegateCallBack_needRefreshWithTareget:baseModel._target];
    }
}

/// 移除会话
- (void)ChatMsgManagerDelegateCallBack_receiveRemoveMessage:(MessageBaseModel *)baseModel {
    [self solveRemoveType:baseModel];
    
    if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_removeSessionWithTarget:)]) {
        [self.delegate MessageManagerDelegateCallBack_removeSessionWithTarget:baseModel._target];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MTBadgeCountChangedNotification object:nil];
}

// 撤回消息
- (void)ChatMsgManagerDelegateCallBack_receiveReSendMessage:(MessageBaseModel *)baseModel
{
    [self solveResendMessage:baseModel];
    
    // 发送刷新委托
    if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_reSendRefreshWithMessageBaseModel:)])
    {
        [self.delegate MessageManagerDelegateCallBack_reSendRefreshWithMessageBaseModel:baseModel];
    }
}

// 好友同步
- (void)ChatMsgManagerDelegateCallBack_receiveRelationMessage:(MessageBaseModel *)message {
    // TODO: 好友同步指令
}

/// 完成了下锚点的打包
- (void)ChatMsgManagerDelegateCallBack_anchorAttachMessageWithContactModel:(ContactDetailModel *)contactModel baseModel:(MessageBaseModel *)baseModel {
    // 1.写入消息列表
    [[MsgSqlMgr share] insertBatchData:[NSArray arrayWithObject:baseModel] WithTag:table_msg];
    
    // 2.写入联系人列表
    [[MsgSqlMgr share] writeMessageListInfoToContactTableWith:contactModel];
    
    // 3.发送刷新列表委托
    if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_needRefreshWithMessageBaseModel:)]) {
        [self.delegate MessageManagerDelegateCallBack_needRefreshWithMessageBaseModel:baseModel];
    }
    else if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_needRefreshWithTareget:)])
    {
        [self.delegate MessageManagerDelegateCallBack_needRefreshWithTareget:baseModel._target];
    }
}

- (void)ChatMsgManagerDelegateCallBack_unmoorAttachMessageWithBaseModel:(MessageBaseModel *)baseModel socketMessage:(NSString *)socketMessage {
    [[MsgSqlMgr share] insertMessageListBatchData:@[baseModel] WithTag:table_msg];
    
    [[SendMessageManager share] sendMessage:baseModel socketString:socketMessage];
}

#pragma mark - MessageTimerManager Delegate
// 发送消息超时的委托回调
- (void)MessageTimerManagerDelegateCallBack_timerOutWithCid:(long long)cid
{
    // 开启轮询login
    self.socketLogin = NO;
    [self socketLogin];
}

// login超时委托回调
- (void)MessageTimerManagerDelegateCallBack_timerOutForLogin
{
    self.socketLogin = NO;
    // socket重连
    [[SocketManager share] closeSocket];
    [[SocketManager share] openSocket];
}

// loginKeep超时委托回调
- (void)MessageTimerManagerDelegateCallBack_timerOutForLoginKeep
{
    self.socketLogin = NO;
    [self socketLogin];
}

#pragma mark - AudioDownloadDAL Delegate

- (void)AudioDownloadManagerDelegateCallBack_finishDownloadWith:(MessageBaseModel *)baseModel armSource:(NSData *)armSource isSuccess:(BOOL)isSuccess
{
    if (isSuccess)
    {
        long long timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
        NSString *strDate = [NSString stringWithFormat:@"%lld",timeStamp];
        
        // 生成路径,并且写入沙盒
        NSString *strAmr = [[MsgFilePathMgr share] getMessageDirFilePathWithFileName:strDate extension:extension_amr uid:baseModel._target];

        NSString *strWav = [[MsgFilePathMgr share] getMessageDirFilePathWithFileName:strDate extension:extension_wav uid:baseModel._target];
        dispatch_async(dispatch_queue_create("write receive amr", DISPATCH_QUEUE_SERIAL), ^{
            // 写入AMR
            [armSource writeToFile:strAmr atomically:YES];
            
            // 转换并写入WAV
            [VoiceConverter amrToWav:strAmr wavSavePath:strWav];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // 生成相对路径
                NSString *relativeAmr = [[MsgFilePathMgr share] getRelativePathWithAllPath:strAmr];
                NSString *relativeWav = [[MsgFilePathMgr share] getRelativePathWithAllPath:strWav];
                
                // 生成相对路径
                [baseModel set_nativeOriginalUrl:relativeWav];
                [baseModel set_nativeThumbnailUrl:relativeAmr];
                
                if (baseModel._markFromReceive)
                {
                    baseModel._markReaded = YES;
                }
                
                // 更新数据库
                [[MsgSqlMgr share] insertBatchData:[NSArray arrayWithObject:baseModel] WithTag:table_msg];
                
                // 发送刷新委托
                if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_needRefreshWithTareget:)])
                {
                    [self.delegate MessageManagerDelegateCallBack_FinishDownAudioWithMessageBaseModel:baseModel];
                }
            });
        });
        
    }
}

#pragma mark - AttachMentDownloadDAL Delegate
- (void)AttachmentDownloadDALDelegateCallBack_managerDataWithProgress:(float)progress
{
   if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_DataWithProgress:)])
   {
       [self.delegate MessageManagerDelegateCallBack_DataWithProgress:progress];
   }
}

- (void)AttachmentDownloadDALDelegateCallBack_finishWithDownloadMessageModel:(MessageBaseModel *)baseModel fileData:(NSData *)imgData
{
    // 1.文件写入沙盒
    dispatch_async(dispatch_queue_create("write OffLine File", DISPATCH_QUEUE_SERIAL), ^{
        
        // 1.得到扩展名
        NSString *strLastComponent;
        NSString *strExtension;
        
        // 2.生成文件名
        NSString *strFileName;
        
        // 3.生成全路径
        NSString *strPath;
        
        // 1.得到扩展名
        strLastComponent = [baseModel.attachModel.fileName lastPathComponent];
        strExtension = [strLastComponent pathExtension];
        
        // 2.生成文件名
        strFileName = [NSString stringWithFormat:@"%lld.%@",baseModel._clientMsgId,strExtension];
        
        // 3.生成全路径
        strPath = [[MsgFilePathMgr share] getMessageDirNamePathWithUid:baseModel._target];
        strPath = [strPath stringByAppendingPathComponent:strFileName];
        [imgData writeToFile:strPath atomically:YES];
        
        // 回归主线程
        dispatch_async(dispatch_get_main_queue(), ^{
        
            // 4.修改内容
            NSString *strRelative = [[MsgFilePathMgr share] getRelativePathWithAllPath:strPath];
            baseModel._nativeThumbnailUrl = strRelative;
            baseModel._nativeOriginalUrl = strRelative;
            [baseModel set_markCompleted:YES];
            
            // 1、更新消息表数据 把附件地址存入
            [[MsgSqlMgr share] insertBatchData:[NSArray arrayWithObjects:baseModel, nil] WithTag:table_msg];
            
            if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_AttachDownloadFinishWithFileUrl:)])
            {
                [self.delegate MessageManagerDelegateCallBack_AttachDownloadFinishWithFileUrl:strRelative];
            }
        });
    });
}

- (void)AttachmentDownloadDALDelegateCallBack_failManagerReceiveAttachmentMessageWithBaseModel:(MessageBaseModel *)baseModel Message:(NSString *)message
{
    if ([self.delegate respondsToSelector:@selector(MessageManagerDelegateCallBack_AttachDownloadFailWithMessage:)])
    {
        [self.delegate MessageManagerDelegateCallBack_AttachDownloadFailWithMessage:message];
    }
}
#pragma mark - Init
- (MessageOfflineDAL *)msgOfflineDAL {
    if (!_msgOfflineDAL) {
        _msgOfflineDAL = [[MessageOfflineDAL alloc] init];
        [_msgOfflineDAL setDelegateMsgOffline:self];
    }
    return _msgOfflineDAL;
}

- (AudioDownloadManager *)audioDownloadManager {
    if (!_audioDownloadManager)
    {
        _audioDownloadManager = [[AudioDownloadManager alloc] init];
        [_audioDownloadManager setDelegate:self];
    }
    return _audioDownloadManager;
}

- (AttachmentDownloadDAL *)attachmentDAL{
    if (!_attachmentDAL)
    {
        _attachmentDAL = [AttachmentDownloadDAL new];
        [_attachmentDAL setDelegate:self];
    }
    return _attachmentDAL;
}

- (dispatch_queue_t)offlineQueue {
    if (!_offlineQueue) {
        _offlineQueue = dispatch_queue_create("IM.offline", DISPATCH_QUEUE_SERIAL);
    }
    return _offlineQueue;
}

@synthesize messageQueue = _messageQueue;

- (dispatch_queue_t)messageQueue {
    if (!_messageQueue) {
        _messageQueue = dispatch_queue_create("IM.message", DISPATCH_QUEUE_SERIAL);
    }
    
    return _messageQueue;
}

- (NSMutableDictionary *)ignoreCacheRequestDictionary {
    if (!_ignoreCacheRequestDictionary) {
        _ignoreCacheRequestDictionary = [NSMutableDictionary dictionary];
    }
    return _ignoreCacheRequestDictionary;
}

@end
