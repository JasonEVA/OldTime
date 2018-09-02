//
//  MessageManager.h
//  Titans
//
//  Created by Remon Lv on 14-9-2.
//  Copyright (c) 2014年 Remon Lv. All rights reserved.
//  消息统一管理单例

#import <UIKit/UIKit.h>
#import "IMEnum.h"

@class MessageBaseModel, ContactDetailModel, UserProfileModel, AttachmentUploadModel, MessageRelationValidateModel,MessageRelationGroupModel,MessageRelationInfoModel;

extern NSString *const MTBadgeCountChangedNotification; // 角标总数变化
extern NSString *const MTUserInfoChangeNotification; // 用户信息变更(主要用于头像清理缓存)

typedef void(^MTSuccessCompletion)(BOOL success);
typedef void(^MTUserPrfileCompletion)(UserProfileModel *model);;

@class SuperGroupListModel;

@protocol MessageManagerDelegate <NSObject>

@optional

/**
 *  消息重新刷新显示
 *
 *  target＝nil 时为重连成功，若在聊天界面需获取最新消息，并重新获取最新纪录
 *
 *  @param target 某一个会话对象需要刷新
 */
- (void)MessageManagerDelegateCallBack_needRefreshWithTareget:(NSString *)target;

/**
 *  发送消息后生成消息的回调
 *
 *  在聊天界面下使用该回调
 *
    [self.showingMessages addObject:message];
    // do Something
 *
 *  @param model 生成的消息,该消息状态为发送中
 */
- (void)MessageManagerDelegateCallBack_needRefreshWithMessageBaseModel:(MessageBaseModel *)model;

/**
 *  撤回消息后收到的撤回类型的消息的回调
 *
    model.content = {\"clientMsgId\":1456981986187,\"msgId\":1456982289436,\"type\":\"Alert\",\"content\":\"William Zhang啊撤回了一条消息\"}
    content中存放JSON格式数据
 
    例子:
    MessageBaseModel *internalMessage = [model getContentBaseModel];
    // do Something
 *
 *  @param model 撤回类型的消息 content中clientMsgId和msgId匀为要替换的老消息的参数值，type和content为要替换的参数值
 */
- (void)MessageManagerDelegateCallBack_reSendRefreshWithMessageBaseModel:(MessageBaseModel *)model;

/**
 *  收到移除会话指令 （多为跨设备同步数据）
 *
 *  @param target 待移除的会话目标
 */
- (void)MessageManagerDelegateCallBack_removeSessionWithTarget:(NSString *)target;

/**
 *  收到清除未读条数指令
 *
 *  @param target 待清楚未读条数的会话目标
 */
- (void)MessageManagerDelegateCallBack_clearUnreadWithTarget:(NSString *)target;

/**
 *  接收到别人发送来的消息 (也有可能是自己跨设备发送的同步消息) 
 *
 *  在聊天界面下使用该回调
 *
 *  @param model 接收到的消息
 */
- (void)MessageManagerDelegateCallBack_receiveMessage:(MessageBaseModel *)model;

/**
 *  发送消息成功后收到的回执
 *
 *  有效字段 _clientMsgId、_msgId、_createDate
 *
 *  使用_clientMsgId确认是否是同一条消息
 *
 *  @param model 消息回执
 */
- (void)MessageManagerDelegateCallBack_synchMessage:(MessageBaseModel *)model;

/**
 *  发送消息失败重新发送后需要移除的消息
 *
 *  使用_clientMsgId做去重
 *
 *  @param model 待删除消息
 */
- (void)MessageManagerDelegateCallBack_deleteMessage:(MessageBaseModel *)model;

/**
 *  接收对方已经读消息的指令
 *
 *  获取已读_msgId
 *  long long readedMsgId = [model getMsgId];
    // do something
 *
 *  @param model 已读消息
 */
- (void)MessageManagerDelegateCallBack_markReadedMessage:(MessageBaseModel *)model;

/**
 *  联系人、群信息改变刷新回调
 *
 *  联系人姓名、群成员增删等
 *
 *  @param userProfile
 */
- (void)MessageManagerDelegateCallBack_refreshContactProfileRefresh:(UserProfileModel *)userProfile;

/// 离线消息成功刷新委托
- (void)MessageManagerDelegateCallBack_needRefreshWithOfflineMessage DEPRECATED_ATTRIBUTE;

/**
 *  附件下载进度
 *
 *  @param progress 0.08
 */
- (void)MessageManagerDelegateCallBack_DataWithProgress:(float)progress;

/**
 *  附件下载完成
 *
 *  得到完整路径方法
    NSString *fullPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:filePath];
    // do something
 *
 *  @param filePath 附件路径
 */
- (void)MessageManagerDelegateCallBack_AttachDownloadFinishWithFileUrl:(NSString *)filePath;

/**
 *  附件下载失败
 *
 *  @param message 失败原因
 */
- (void)MessageManagerDelegateCallBack_AttachDownloadFailWithMessage:(NSString *)message;

/**
 *  语音数据下载完成回调
 *
 *  NSString *audioPath = [[MsgFilePathMgr share] getAllPathWithRelativePath:model._nativeOriginalUrl];
    RMAudioManager *audioManager = [[RMAudioManager alloc] init];
    [audioManager playAudioWithPath:audioPath];
    // do something
 *
 *  @param model 语音下载成功的所在消息
 */
- (void)MessageManagerDelegateCallBack_FinishDownAudioWithMessageBaseModel:(MessageBaseModel *)model;

/**
 *  附件上传回调
 *
 *  @param uploadModel  待上传的model，附件路径在_nativeOriginalUrl
 *  @param progress     上传进度 78% progress为1时上传成功
 *  @param failedReason 上传失败原因 若成功，则为nil
 */
- (void)MessageManagerDelegateCallBack_uploadModel:(MessageBaseModel *)uploadModel progress:(double)progress failedReason:(NSString *)failedReason;

/**
 *  接收到新消息回调（主要用于播放声音、震动）
 */
- (void)MessageManagerDelegateCallBack_PlaySystemKind;

/**
 *  收到联系人更新消息，增量获取联系人后提示更新的委托
 */
- (void)MessageManagerDelegateCallBack_needRefreshRelationFromSQL;

@end

@interface MessageManager : NSObject

// 委托回调
@property (nonatomic,weak) id <MessageManagerDelegate> delegate;

/// 正常消息队列
@property (nonatomic, readonly) dispatch_queue_t messageQueue;

/**
 *  上传附件进度，以附件的原始路径为key（_nativeOriginalUrl, 70%）
 */
@property (nonatomic, readonly) NSDictionary *attachUploadProgressDictionary;

// 单例
+ (MessageManager *)share;


/**
 *  服务端IP配置
 *
 *  @param appName
 *  @param appToken
 *  @param wsIP      websocket IP
 *  @param httpIP    http IP
 *  @param testIP    监测 IP (监测网络情况)
 *  @param loginType 区分登录类型,用于给服务端绑定推送证书, 可以使用bundle id 无区别请填nil
 */
+ (void)setAppName:(NSString *)appName appToken:(NSString *)appToken wsIP:(NSString *)wsIP httpIP:(NSString *)httpIP testIP:(NSString *)testIP loginType:(NSString *)loginType;

/**
 *  配置APNS
 *
 *  @param deviceToken 设备Token
 */
+ (void)setRemoteNotificationWithDeviceToken:(NSData *)deviceToken;

/**
 *  配置Voip
 *
 *  @param voipToken 
 */
+ (void)setVoipDeviceWithToken:(NSString *)voipToken;

/**
 *  设置用户Id及昵称
 *
 *  @param userId   用户Id
 *  @param nickName 昵称
 */
+ (void)setUserId:(NSString *)userId nickName:(NSString *)nickName;

/// 登录
- (void)login;
/// 登出
- (void)logout;

/**
 *  用户信息更改后更改NickName
 *
 *  @param nickName 更改后的nickName
 */
- (void)setNickName:(NSString *)nickName;

/**
 *  获取用户的id
 *
 *  @return 用户id
 */
+ (NSString *)getUserID;

/**
 *  获取用户的nickName
 *
 *  @return 用户的nickName
 */
+ (NSString *)getNickName;

/**
 获取当前服务器毫秒级时间戳
 
 @return 服务器毫秒级时间戳
 */
+ (long long)currentServerMsTimestamp;

// ************** http请求 **************//
#pragma mark - Http Post Get

/*---------------会话列表--------------------*/

/**
 *  获取会话列表
 */
- (void)getMessageList;

/**
 *  移除单个聊天会话
 *
 *  @param deleteSessionUid 待删除的会话Uid
 *  @param completion       删除是否成功回调
 */
- (void)removeSessionUid:(NSString *)deleteSessionUid completion:(MTSuccessCompletion)completion;

/*---------------聊天会话--------------------*/

/**
 *  获取聊天的历史消息
 *
 *  获取最新历史后在socket没有断开前不重新获取最新历史，返回completion(nil,NO)
 *
 *  @param uid          会话uid
 *  @param count        获取条数
 *  @param endTimestamp 截止此条时间戳前的数据（1970年时间戳 * 1000） 要获取最新数据填-1
 *  @param completion   完成回调（if (success = NO) messages = nil）
 */
- (void)getHistoryMessageWithUid:(NSString *)uid
                    messageCount:(NSInteger)count
                    endTimestamp:(long long)endTimestamp
                      completion:(void(^)(NSArray *messages, BOOL success))completion;

/**
 *  标记或取消标记消息
 *
 *  @param message 待操纵的消息
 */
- (void)markMessage:(MessageBaseModel *)message;

/**
 *  标记或取消标记消息
 *
 *  @param message    待操纵的消息
 *  @param completion 是否成功回调
 */
- (void)markMessage:(MessageBaseModel *)message completion:(MTSuccessCompletion)completion;

/**
 *  撤回消息
 *
 *  @param message    待撤回的消息
 *  @param completion 撤回是否成功回调
 */
- (void)recallMessage:(MessageBaseModel *)message completion:(MTSuccessCompletion)completion;

/**
 *  合并(逐条)消息转发
 *
 *  @param messages   待转发的消息
 *  @param title      合并消息
 *  @param toUsers    待接收用户
 *  @param isMerge    合并还是逐条转发
 *  @param completion 转发完成回调
 */
- (void)forwardMergeMessages:(NSArray <MessageBaseModel *>*)messages
                       title:(NSString *)title
                     toUsers:(NSArray <ContactDetailModel *>*)toUsers
                     isMerge:(BOOL)isMerge
                  completion:(MTSuccessCompletion)completion;

/**
 *  发送图文消息
 *
 *  @param description  正文摘要
 *  @param title        标题
 *  @param picUrl       图片url
 *  @param url          H5页面url
 *  @param toUsers      待发送对象
 *  @param completion   委托完成回调
 */
// 发送图文接口暂时不用
//- (void)sendNewsMessage:(NSString *)description
//                  title:(NSString *)title
//                 picUrl:(NSString *)picUrl
//                    url:(NSString *)url
//                toUsers:(NSArray *)toUsers
//             completion:(MTSuccessCompletion)completion;

// 开始下载附件
- (void)getAttachmentWithBaseModel:(MessageBaseModel *)model;

/**
 *  请求将消息设置为已读
 *
 *  若要将聊天对象角标清空，即使无未读消息也要传空数据
 *
 *  @param uid      待标记已读对象Uid
 *  @param messages 待标记已读的消息[messageBaseModel]
 */
- (void)sendReadedRequestWithUid:(NSString *)uid messages:(NSArray *)messages;


/**
 *  请求将该登录账号下所有此tag的会话置为已读（根据tag清角标，一键已读，一键退朝）
 *
 *
 *  @param tag      会话的标签
 */
- (void)sendReadedSessionRequestWithTag:(NSString *)tag completion:(MTSuccessCompletion)completion;

/**
 * 会话角标批量清零
 *
 *  @param tag      会话的用户数组
 */
- (void)sendReadedSessionRequestWithSessionNameList:(NSArray *)sessionNameList;

/*---------------群组--------------------*/

/**
 *  获取所有讨论组
 *
 *  @param fromCache  从缓存中获取，缓存2分钟
 *  @param completion 委托回调
 */
- (void)loadGroupListFromCache:(BOOL)fromCache completion:(void (^)(NSArray<UserProfileModel *> *groupList, BOOL success))completion;

/**
 *  获取群列表
 *  @param fromChache 从缓存中获取
 */
- (void)getSuperGroupListFromChache:(BOOL)fromChache completion:(void (^)(BOOL success, NSArray <SuperGroupListModel *> *modelArray))completion;


/**
 *  新建讨论组自动添加自己
 *
 *  @param userIds    待新建的群组成员 自动添加自己
 *  @param completion 创建是否成功回调，失败时Profile=nil
 */
- (void)createGroupWithUserIds:(NSArray *)userIds completion:(void (^)(UserProfileModel *, BOOL))completion;

/**
 *  新建讨论组 自动添加自己
 *
 *  @param userIds    待新建的群组成员 自动添加自己
 *  @param tag        群组标签 (自定义) 若无填nil
 *  @param completion 创建是否成功回调，失败时Profile=nil
 */
- (void)createGroupWithUserIds:(NSArray *)userIds tag:(NSString *)tag completion:(void (^)(UserProfileModel *, BOOL))completion;

/**
 *  讨论组中添加讨论组成员,添加成功会触发MessageManagerDelegateCallBack_refreshContactProfileRefresh
 *
 *  @param groupUid     群组Uid
 *  @param userIds      待加入的群成员Uid
 *  @param completion   添加成员是否成功回调
 */
- (void)groupSessionUid:(NSString *)groupUid addUserIds:(NSArray *)userIds completion:(MTSuccessCompletion)completion;

/**
 *  讨论组删除讨论组成员
 *
 *  @param groupUid   群组Uid
 *  @param memberId   待删除群成员Uid
 *  @param completion 删除是否成功回调
 */
- (void)groupSessionUid:(NSString *)groupUid deleteMemberId:(NSString *)memberId completion:(MTSuccessCompletion)completion;

/**
 *  修改群名
 *
 *  @param groupUid    待修改的群组Uid
 *  @param changedName 待修改的名称
 */
- (void)groupSessionUid:(NSString *)groupUid changeName:(NSString *)changedName;

/**
 *  修改讨论组免打扰设置
 *
 *  @param groupUid    待修改的群组Uid
 *  @param receiveMode 免打扰设置
 */
- (void)groupSessionUid:(NSString *)groupUid receiveMode:(userProfileReceiveMode)receiveMode completion:(MTSuccessCompletion)completion;

/*---------------Deprecated--------------------*/
/**
 *  (放弃离线机制，使用获取会话列表再获取消息数据）请使用getMessageList
 *  获取服务器离线消息
 *  功能：将会分页请求离线消息，并且存入本地数据库，直到全部完成
 *  调用时机：在程序每次回到前台时候调用
 *  约束提醒：需要在所有安全验证之后执行
 *  回调：通过MessageManagerDelegateCallBack_needRefreshMessage
 或者MessageManagerDelegateCallBack_needRefreshWithTareget:(NSString *)target 回调，然后openSocket
 */
- (void)getOfflineMessage DEPRECATED_ATTRIBUTE;

/**
 *  获取单个用户与某个会话历史聊天消息 根据该会话最后一条消息的MsgId判断需不需要拉
 *  功能：获取与会话历史消息，并且存入本地数据库，直到全部完成
 *  调用时机：在点击某个会话列表的时候
 *  约束提醒：需要在所有安全验证之后执行
 */
- (void)getHistoryMessageWithUid:(NSString *)uid MessageCount:(NSInteger)count DEPRECATED_ATTRIBUTE;

/**
 *  查询某一个用户信息，并存入联系人列表
 *
 *  @param target 联系人uid
 */
- (void)getUserInfoWithUid:(NSString *)uid;


/**
 验证并请求会话信息，modify一致时不请求

 @param sessionInfo 会话信息
 */
- (void)verifyAndRequestUserInfoWithSessionInfo:(ContactDetailModel *)sessionInfo;
/**
 通过网络请求某个会话的详情
 
 @param groupId 会话Id
 @param completion 详情回调
 */

- (void)MTRequestGroupInfoWirhGroupId:(NSString *)groupId completion:(MTUserPrfileCompletion)completion;

// ************** 好友Http **************//
#pragma mark - 好友分组 HTTP
/**
 *  添加好友关系 （需要对方验证）
 *
 *  @param toUserId        待添加好友UID
 *  @param remark          待添加好友备注
 *  @param content         发送验证信息
 *  @param relationGroupId 待加入的分组 默认分组填－1
 *  @param completion      添加是否成功的回调
 */
- (void)addRelationValidateToUser:(NSString *)toUserId
                           remark:(NSString *)remark
                          content:(NSString *)content
                  relationGroupId:(long)relationGroupId
                       completion:(MTSuccessCompletion)completion;

/**
 *  网络获取好友验证列表
 *
 *  @param comletion 回调
 */
- (void)loadServerRelationValidateListCompletion:(void (^)(NSArray<MessageRelationValidateModel *> *validlist , BOOL success))completion;

/**
 *  处理好友请求
 *
 *  @param model           好友请求model
 *  @param state           2:同意 3:拒绝 4:忽略
 *  @param relationGroupId 好友分组id 不需要时填-1
 *  @param remark          备注
 *  @param content         验证内容
 *  @param completion      是否完成
 */
- (void)dealRelationWithModel:(MessageRelationValidateModel *)model
                validateState:(NSInteger)state
              relationGroupId:(long)relationGroupId
                       remark:(NSString *)remark
                      content:(NSString *)content
                   completion:(MTSuccessCompletion)completion;


/**
 *  获取当前用户的好友列表
 */
- (void)loadReLationGroupListcompletion:(void(^)(NSArray<MessageRelationInfoModel *> *array, BOOL success))completion;

/**
 *  获取指定用户的好友列表
 *
 *  @param username userName
 */
//- (void)loadRelationGroupListWithUserName:(NSString *)username;


/**
 *  增量获取好友及分组
 *  @param istotal false 增量 true 全量 默认是增量
 *  @param completion 是否成功回调
 */
- (void)loadRelationGroupInfoWithTotalFlag:(BOOL)istotal Completion:(MTSuccessCompletion)completion;

/**
 *  创建好友分组
 *
 *  @param groupName  待创建好友分组名称
 *  @param completion 回调是否成功
 */
- (void)createRelationGroupWithName:(NSString *)groupName completion:(void (^)(MessageRelationGroupModel *model, BOOL success))completion;

/**
 *  修改好友分组
 *
 *  @param groupmodel 好友分组模型
 *  @param completion 完成✅回调
 */
- (void)modifyRelationGroupInfoGroupModel:(MessageRelationGroupModel *)groupmodel comletion:(MTSuccessCompletion)completion;

/**
 *  删除好友分组
 *
 *  @param relationGroupId 好友分组ID
 */
- (void)deleteRelationGroupWithRelationGroupId:(long)relationGroupId completion:(MTSuccessCompletion)completion;

/**
 *  移动好友
 *
 *  @param relationName    好友用户名
 *  @param relationGroupID 好友分组ID
 *  @param completion      完成回调
 */
- (void)transferRelationWithRelationName:(NSString *)relationName
                         RelationGroupID:(NSNumber *)relationGroupID
                              completion:(void(^)(BOOL isSuccess))completion;

/**
 *  删除好友
 *
 *  @param  uid         用户名
 *  @param  completion  回调 处理是否成功
 */
- (void)deleteRelationWithUid:(NSString *)uid completion:(MTSuccessCompletion)completion;

/**
 *  修改备注
 *
 *  @param  relationName         用户名
 *  @param  remark               备注名
 *  @param  completion  回调 处理是否成功
 **/
- (void)remarkRelationWithUid:(NSString *)relationName remark:(NSString *)remark completion:(MTSuccessCompletion)completion;

/**
 *  精确搜索 (用户名或者手机号)
 *
 *  @param relationValue 用户名或者手机号
 *  @param completion   添加是否成功的回调
 */
- (void)searchRelationUserWithRelationValue:(NSString *)relationValue completion:(void(^)(NSArray<MessageRelationInfoModel *> *array, BOOL success))completion;


// ************** 好友SQL **************//
#pragma mark - 好友SQL
/**
 * 批量插入好友信息
 *
 *  @param array
 */
- (void)insertRelationInfoWithArray:(NSArray <MessageRelationInfoModel *>*)array;
/**
 * 删除好友分组
 *
 * @param  relationGroupId 好友分组id
 */
- (void)deleteRelationGroupWithRelationGroupId:(long)relationGroupId;
/**。。。
 *  删除好友
 *
 *  @param  relationName 好友用户名
 */
- (void)deleteRelationInfoWithRelationName:(NSString *)relationName;
/**
 *  修改好友分组
 *
 *  @param relationGroup  MessageRelationGroupModel
 */
- (void)updateRelationGroup:(MessageRelationGroupModel *)relationGroup;
/**
 *  修改好友信息
 *
 *  @param  relationInfo 好友MessageRelationInfoModel名
 */
- (void)updateRelationInfo:(MessageRelationInfoModel *)relationInfo;
/**
 *  获取所有好友分组
 *
 *  @return  @[MessageRelationGroupModel_objs]
 */
- (NSArray *)queryRelationGroups;
/**
 *  获取某分组下的所有好友
 *
 *  @param  relationGroupId 好友分组id
 *  @return  @[MessageRelationInfoModel_objs]
 */
- (NSArray *)queryRelationInfoWithRelationGroup:(long)relationGroupId;
/**
 *  对应分组下是否有对应的id的用户
 *
 *  @param relationGroupId 分组id。传-1时，搜素全部的好友数据
 *  @param userId          好友usershowid
 */
- (BOOL )queryRelationInfoWithRelationGroup:(long)relationGroupId userID:(NSString *)userId;
/**
 *  获取好友中有对应用户名的，或者有对应备注的用户
 *  ！模糊查询
 *  @param nickName 好友用户名
 *  @param remark   备注用户
 *
 */
- (NSArray *)queryRelationInfoWithNickName:(NSString *)nickName remark:(NSString *)remark;
/**
 *  获取数据库中对应用户名的用户
 *
 *  @param userId 用户名
 */
- (MessageRelationInfoModel *)queryRelationInfoWithUserID:(NSString *)userId;
// ************** 好友SQL **************//

#pragma mark - Send Message
/**
 *  发送ws消息
 *
 *  @param to          发送对象
 *  @param nick        发送对象nickName
 *  @param content     文本为内容，语音、图片、应用消息都有各自的JSON
 *  @param msgType     msg_personal_text   语音、图片使用anchorAttachMessageType:toTarget:nickName:primaryPath:minorPath:
 */
- (void)sendMessageTo:(NSString *)to nick:(NSString *)nick WithContent:(id)content Type:(Msg_type)msgType;
/**
 *  发送ws消息
 *
 *  @param to          发送对象
 *  @param nick        发送对象nickName
 *  @param content     文本为内容，语音、图片、应用消息都有各自的JSON
 *  @param msgType     msg_personal_text、msg_personal_voice、msg_personal_image,
 *  @param atUser      成员数组 (showId@Name)
 */
- (void)sendMessageTo:(NSString *)to nick:(NSString *)nick WithContent:(id)content Type:(Msg_type)msgType atUser:(NSArray *)atUserList;

/**
 *  发送附件消息下锚(语音、文字、视频等)
 *
 *  附件为语音只用填写primaryPath即可，语音格式为WAV格式
 *
 *  @param type        附件消息类型
 *  @param toTarget    发送对象Uid
 *  @param nickName    发送对象的名称
 *  @param primaryPath 主要数据的本地路径(相对路径)
 *  @param minorPath   次要数据的本地路径(相对路径)
 *
 *  @return 待发送的消息 (使用cid做)
 */
- (MessageBaseModel *)anchorAttachMessageType:(Msg_type)type
                                     toTarget:(NSString *)toTarget
                                     nickName:(NSString *)nickName
                                  primaryPath:(NSString *)primaryPath
                                    minorPath:(NSString *)minorPath;

/**
 *  发送用户信息更改的消息
 *
 *  @param modified 更改后的modified
 */
- (void)sendUserModifiedWithModified:(long long)modified;

/**
 *  从服务器下载语音资源  成功后通过委托回调刷新
 *
 *  @param baseModel MessageBaseModel
 */
- (void)downloadAudioSourceWithModel:(MessageBaseModel *)baseModel;


/**
 *  上传图片，语音失败情况下标记为发送失败
 *
 */
- (void)markUploadingMessageToFaild:(MessageBaseModel *)baseModel;

/**
 *  重新发送数据之前，清理数据，针对与文本，语音和图片标记为发送waiting状态
 *
 */
- (void)shouldReSendMessageWith:(MessageBaseModel *)baseModel;

/**
 *  创建群组成功保存群组信息
 *
 */
- (void)saveGroupModel:(UserProfileModel *)model;

/**
 *  发送最后一次心跳
 仅在注销用户的时候使用
 */
- (void)sendLastHeartbeat MintcodeIMDeprecated("不需要调用该方法");

#pragma mark - SQLAction

/**
 *  删除对象会话，数据库操作
 *
 *  @param uid 待删除对象会话
 */
- (void)deleteMessageListWithUid:(NSString *)uid;

/**
 *  设置欢迎语句
 *
 *  @param welcomeMessage 欢迎语句
 */
- (void)setWelcomeMessage:(NSString *)welcomeMessage uid:(NSString *)uid nickName:(NSString *)nickName;

#pragma mark - Query
/**
 *  获取消息列表数据 默认包涵应用类别
 *
 *  @return ContactDetailModel数组
 */
- (void)getMessageListCompletion:(void(^)(NSArray <ContactDetailModel *>*))completion;


/**
 根据tag获取消息表

 @param tag 标签
 @param completion 主线程的回调
 */
- (void)queryMessageListByTag:(NSString *)tag completion:(void(^)(NSArray <ContactDetailModel *>*))completion;


/**
 根据tag分页请求消息列表

 @param tag 标签，nil为全部
 @param limit 数量,-1为全部。
 @param offset 偏移量
 @param completion 主线程回调
 */
- (void)queryMessageListByTag:(NSString *)tag limit:(NSInteger)limit offset:(NSInteger)offset completion:(void(^)(NSArray <ContactDetailModel *> *))completion;


/**
 分页请求除某些tag之外的消息列表

 @param tags 过滤的tag
 @param limit 数量,-1为全部
 @param offset 偏移量
 @param completion 主线程回调
 */
- (void)queryMessageListWithoutTags:(NSArray<NSString *> *)tags limit:(NSInteger)limit offset:(NSInteger)offset completion:(void(^)(NSArray <ContactDetailModel *> *))completion;


/**
 *  获取消息列表数据
 *
 *  @param containAppliactions 是否只包含单聊和群聊
 *  @param completion          完成回调
 */
- (void)getMessageListOnlyChat:(BOOL)onlyChat completion:(void(^)(NSArray <ContactDetailModel *>*))completion;
/**
 *  获取群组列表
 *
 *  @param completion ContactDetailModel数组
 */
- (void)getMessageGroupListCompletion:(void(^)(NSArray *))completion;

/**
 *  查询某个人的一批消息(从最新按时间逆序的若干条数据)
 *
 *  @param uid     uid
 *  @param count   信息条数
 *
 *  @return （MessageBaseModel）
 */
- (void)queryBatchMessageWithUid:(NSString *)uid MessageCount:(NSInteger)count completion:(void(^)(NSArray<MessageBaseModel *> *))completion;

/**
 *  查询某个人的全部图片消息(从最新按时间逆序的若干条数据)
 *
 *  @param uid     uid
 *  @param count   信息条数
 *
 *  @return （MessageBaseModel）
 */
- (NSArray *)queryBatchImageMessageWithUid:(NSString *)uid;

/**
 *  查询一个联系人/群的所有未读信息
 *
 *  @param uid 联系人唯一标识符 msgId 唯一标识符
 *
 *  @return 用户信息msgId数组(NSString)格式 取出大于该msgId的未读消息
 */
- (void)getAllUnReadedMessageListWithUid:(NSString *)uid msgId:(long long)msgId completion:(void(^)(NSArray *))completion;;

/**
 *  更新会话的草稿数据
 *
 *  @param target 待更新对象Uid
 *  @param draft  草稿信息
 */
- (void)updateDraftWithTarget:(NSString *)target draft:(NSAttributedString *)draft;
/**
 *  更新会话中是否有人@自己
 *
 *  @param target 会话Uid
 *  @param atMe   是否@自己
 */
- (void)updateAtMeWithTarget:(NSString *)target atMe:(BOOL)atMe;
/**
 *  查询某个对象的会话
 *
 *  @param uid 对象标识符
 */
- (void)querySessionDataWithUid:(NSString *)uid completion:(void(^)(ContactDetailModel *))completion;

/**
 查询某个对象的会话

 @param uid 对象标识符
 @return 会话对象
 */
- (ContactDetailModel *)querySessionDataWithUid:(NSString *)uid;

/**
 *  查询总的未读消息条数
 *
 *  @return 未读条数
 */
- (void)queryAllUnreadMessageCountCompletion:(void(^)(NSInteger))completion;

/**
 *  查询不包含某会话的未读消息条数
 *
 *  @param uid 不包含的uid
 *
 *  @return NSInteger
 */
- (void)queryUnreadMessageCountWithoutUid:(NSString *)uid completion:(void(^)(NSInteger))completion;
/**
 *  查询一个联系人/群的信息
 *
 *  @param uid 联系人唯一标识符
 *
 *  @return 用户信息
 */
- (UserProfileModel *)queryContactProfileWithUid:(NSString *)uid;

/**
 *  查询一个联系人的信息
 *
 *  @param nickName 联系人昵称
 *
 *  @return 用户信息
 */
- (UserProfileModel *)queryContactProfileWithNickName:(NSString *)nickName;

/**
 *  全局搜索的数据查询
 *
 *  @param keyword 关键词
 *
 *  @return 搜索结果
 */
- (NSArray *)querySearchMessageListWithKeyword:(NSString *)keyword;

/**
 *  单个聊天信息搜索
 *
 *  @param keyword 关键词
 *  @param uid     对象
 *
 *  @return 搜索结果
 */
- (NSArray *)querySearchMessageListWithKeyword:(NSString *)keyword uid:(NSString *)uid;

/**
 *  标记重点
 *
 *  @param baseModel   要标记的model
 *  @param isImportant 是否重点
 */
- (void)markMessageImportantWithModel:(MessageBaseModel *)baseModel important:(BOOL)isImportant;

/**
 *  从某一条信息开始查找之前的历史，包含这条数据
 *
 *  @param sqlID key消息
 *  @param count 查询的条数
 *  @param uid   用户唯一标识符
 *  @return 查询到的数据数组
 */
- (NSArray *)queryOlderMessageHistoryFromSqlID:(long long)sqlID count:(NSInteger)count uid:(NSString *)uid;

/**
 *  从某一条信息开始查找之后的历史，包含这条数据
 *
 *  @param sqlID key消息
 *  @param count 查询的条数
 *  @param uid   用户唯一标识符
 *  @return 查询到的数据数组
 */
- (NSArray *)queryNewerMessageHistoryFromSqlID:(long long)sqlID count:(NSInteger)count uid:(NSString *)uid;
/**
 *  从某一条信息开始查找之后的历史，包含这条数据  --> Event
 *
 *  @param sqlID key消息
 *  @param count 查询的条数
 *  @param uid   用户唯一标识符
 *  @return 查询到的数据数组
 */
- (NSArray *)queryNewerEventMessageHistoryFromCreatDate:(long long)creatDate count:(NSInteger)count uid:(NSString *)uid;
/**
 *  从某一条信息开始查找之前的历史，包含这条数据  --> Event
 *
 *  @param sqlID key消息
 *  @param count 查询的条数
 *  @param uid   用户唯一标识符
 *  @return 查询到的数据数组
 */
- (NSArray *)queryOlderEvevtMessageHistoryFromCreatDate:(long long)creatDate count:(NSInteger)count uid:(NSString *)uid;

/**
 *  单个聊天信息查询 --> @我的消息
 *
 *  @param target     聊天ID
 *
 *  @return 查询结果
 */
- (NSArray *)queryAtMeMessageFromTarget:(NSString *)target;

/**
 *  单个聊天信息查询 --> 图片 OR 文件
 *
 *  @param target     聊天ID
 *
 *  @return 查询结果
 */
- (NSArray *)queryImportantImageMessageFromTarget:(NSString *)target msg_type:(Msg_type)type;
/**
 *  单个聊天信息查询 --> 被标记为重点
 *
 *  @param target     聊天ID
 *
 *  @return 查询结果
 */
- (NSArray *)queryImportantFileAndTextMessageFromTarget:(NSString *)target;
/**
 *  单个聊天信息查询 --> 应用
 *
 *  @param target     聊天ID
 *
 *  @return 查询结果
 */
- (NSArray *)queryAppMessageWithTarget:(NSString *)target;
/**
 *  单个聊天信息查询 --> 某个群成员的所有消息
 *
 *  @param target     聊天ID
 *  @param userName   群成员ID
 *
 *  @return 查询结果
 */
- (NSArray *)querySomeOneAllMessageWithTarget:(NSString *)target userName:(NSString *)userName;
/**
 *  查询消息表里 的某条消息是否与服务器同步的状态一致 (标记重点状态)
 *  important   标记状态
 */
- (BOOL)queryMessageIsImportantWithBaseModel:(MessageBaseModel *)baseModel important:(BOOL)isImportant;
/**
 *  查询某个人是否是某群的群成员
 *  @param userName 群名称
 *  @param UID      此人的UID
 */
- (BOOL)queryPeopleIsGroupMembersWithGroupUserName:(NSString *)userName Show_ID:(NSString *)Show_ID;
/**
 * 查询某个会话中 ,缓存中的最新的消息是不是数据库中最新的
 * @param tager 会话唯一标示符 ,会话名称
 * @param 最新消息的msgid
 *
 */
- (BOOL)queryMessageIsNewestWithTagert:(NSString *)tagert msgid:(long long)msgid;

@end
