#MintcodeIMFramwork 0.1	

##使用cocoapods
初次使用可看教程
[用CocoaPods做iOS程序的依赖管理](http://blog.devtang.com/blog/2014/05/25/use-cocoapod-to-manage-ios-lib-dependency/)

###依赖库

pod 'AFNetworking', '~> 3.0.4'	
pod 'MJExtension', '~> 3.0.10'	
pod 'FMDB', '~> 2.6'	
pod 'SocketRocket', '~> 0.4.2'	
pod 'DateTools', '~> 1.7.0'		
pod 'Reachability', '~> 3.2'

###增加2个lib
libc++.tbd,libz.tbd
![](./Libraries_setup.png)


#MintcodeIM介绍

##Configure
###IMEnum
消息基本类型定义，屏蔽类型等
###IMConfigure
Notification 通知关键词，系统基本信息

##Model
###MessageBaseModel 
消息主体，每一消息的数据，发送文本等
###MessageAppModel		
应用类型消息主体，每一条应用类型消息的数据，标题，内容，事件等
###ContactDetailModel	
消息列表主体，显示列表上会话的消息，会话对象，时间等
###UserProfileModel	
聊天对象主体，存储聊天对象的基本信息，昵称，用户类型，Uid等
###MessageAttachmentModel	
聊天附件主体，附件大小，路径，名字等

##MessageManager
消息进出，发送消息，接收消息，获取历史消息，查看最新消息，撤回功能等一系列消息管理都在此方法中进行，注意使用delegate，详见MessageManager.h

##SuperGroupListModel
群列表，包括头像，昵称，用户类型等

# 使用MintcodeIM

##初始配置
引入头文件:

```
#import<MintcodeIM/MintcodeIM.h>  

NSString *const im_task_uid     = @"PWP16jQLLjFEZXLe@APP";
NSString *const im_approval_uid = @"ADWpPoQw85ULjnQk@APP";
NSString *const im_schedule_uid = @"l6b3YdE9LzTnmrl7@APP";
// 数值在10001-19999之间
typedef NS_ENUM(NSUInteger, IM_Applicaion_Type) {
    IM_Applicaion_task = 10001,
    IM_Applicaion_approval,
    IM_Applicaion_schedule,
};

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    [MessageManager setApplicationConfig:@{im_task_uid:@(IM_Applicaion_task),
                    im_approval_uid:@(IM_Applicaion_approval),                                           					im_schedule_uid:@(IM_Applicaion_schedule)
                                           }];
    [MessageManager setAppName:@"Mintcode" appToken:@"verify-code" wsIP:@"ws://192.168.1.251:2000" httpIP:@"http://192.168.1.251:20001/Mintcode" testIP:@"192.168.1.249" loginType:@"com.mintcode.IM"];
    // loginType 可以使用bundle id来作为区分，用于给服务器绑定推送证书，无填nil
    return YES;
    }
    
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{	// 推送信息配置
    [MessageManager setRemoteNotificationWithDeviceToken:deviceToken];
}
    
```

##设置用户名，昵称并登录
```
[MessageManager setUserId:@"ZBAYNbRqYAUBbjDE12" nickName:@"test_one";
[[MessageManager share] login];
```

##获取用户名和用户ID
```
   NSInteger *nickName = [MessageManager getNickName]; //获取用户的昵称
   NSString *userName = [MessageManager getUserID]; //获取用户的userID
```
##未读消息条数
```
[[MessageManager share] queryAllUnreadMessageCountCompletion:^(NSInteger count) {
	// 刷新或显示UI
}];
```
##不包含某会话的未读消息条数
```
[[MessageManager share] queryUnreadMessageCountWithoutUid:self.strUid completion:^(NSInteger unreadCount) {
	// 刷新或显示UI       
}];
```
##获取列表
###获取聊天列表
```
[[MessageManager share] getMessageListCompletion:^(NSArray<ContactDetailModel *> *arrayList) {
       // 刷新或显示UI
}];
```
###获取聊天消息列表
```
[self.manager queryBatchMessageWithUid:self.sessionModel._target MessageCount:messageCount completion:^(NSArray<MessageBaseModel *> *messages) {
	// 刷新或显示UI   
}];
```
##会话草稿
```
NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"@Andrew" attributes:@{NSLinkAttributeName:@"ZBAYNbRqYAUBbjDE12@Andrew"}];
[[MessageManager share] updateDraftWithTarget:self.strUid draft:self.chatInputView.inputAttributeString];
```
##发送消息
```
// 发送文字
[[MessageManager share] sendMessageTo:@"466@ChatRoom" nick:@"test_two" WithContent:@"你好@Andrew" Type:msg_personal_text atUser:@"ZBAYNbRqYAUBbjDE12@Andrew"];

// 发送语音、图片

NSString *userPath = [[MsgFilePathMgr share] getMessageDirNamePathWithUid:@"ZBAYNbRqYAUBbjDE12"];
// 图片路径
NSString *primaryFullPath = [userPath stringByAppendingPathComponent:@"2011050657.jpg"];
NSString *minorFullPath   = [userPath stringByAppendingPathComponent:@"thunmbnail.jpg"];
NSString *primaryPath = [[MsgFilePathMgr share] getRelativePathWithAllPath:primaryFullPath];
NSString *minorPath = [[MsgFilePathMgr share] getRelativePathWithAllPath:minorFullPath];

// 语音路径
NSString *primaryFullPath = [[MsgFilePathMgr share] getMessageDirFilePathWithFileName:@"2011050657" extension:extension_wav uid:@"ZBAYNbRqYAUBbjDE13"];
NSString *primaryPath = [[MsgFilePathMgr share] getRelativePathWithAllPath:primaryFullPath];


// 语音不用填minorPath
[[MessageManager share] anchorAttachMessageType:msg_personal_image toTarget:@"ZBAYNbRqYAUBbjDE13" nickName:@"test_two" primaryPath:primaryPath minorPath:minorPath];
```
###录音方法
```
// 路径参照上述方法获取
// 录音
NSMutableDictionary * recordSetting = [NSMutableDictionary dictionary];
//设置录音格式  AVFormatIDKey == WAV
[recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
//设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
[recordSetting setValue:[NSNumber numberWithFloat:8000] forKey:AVSampleRateKey];
//录音通道数  1 或 2
[recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
//线性采样位数  8、16、24、32
[recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
//录音的质量
[recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMedium] forKey:AVEncoderAudioQualityKey];
[[AVAudioRecorder alloc] initWithURL:primaryFullPath settings:recordSetting error:nil];

```
##回调详情见 ***MessageManagerDelegate***
```
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

@end

```
##群组
###创建群组
```
[[MessageManager share] createGroupWithUserIds:@[@"ZBAYNbRqYAUBbjDE12", @"ZBAYNbRqYAUBbjDE14", @"ZBAYNbRqYAUBbjDE15"]						
									 tag:@"自定义标签"
                                    completion:^(UserProfileModel *groupProfile, BOOL isSuccess)
     {
     	if (!success) {
     		// 显示失败
     		return;
     	}
     	
     	NSLog(@"groupUid:%@, nickName:%@", groupProfile.userName, groupProfile.nickName);
     }];
```

###邀请加入群聊
```
[[MessageManager share] groupSessionUid:@"446@ChatRoom" addUserIds:@[@"ZBAYNbRqYAUBbjDE16", @"ZBAYNbRqYAUBbjDE17", @"ZBAYNbRqYAUBbjDE18"] completion:^(BOOL success) {
	// 刷新或显示UI
}];
```
###退出或踢出群聊
***踢出功能只限群主***			

```
[[MessageManager share] groupSessionUid:self.groupID deleteMemberId:@"ZBAYNbRqYAUBbjDE18" completion:^(BOOL isSuccess) {
	// 刷新或显示UI
}];
```
###群组免打扰
```
[[MessageManager share] groupSessionUid:self.groupID receiveMode:kUserProfileReceiveAccept completion:^(BOOL success) {
	// 刷新或显示UI
}];
```

###获取群列表
```
/**
 *  获取群列表
 *  @param fromChache 从缓存中获取
 */
[[MessageManager share] getSuperGroupListFromChache:YES completion:^(BOOL  success, NSArray<SuperGroupListModel *> *modelArray) {
    //刷新或显示UI 
 }];
```

##消息操作
###标记或取消重点
```
MessageBaseModel *baseModel = [self.arrayDisplay objectAtIndex:index];
    
/* 在这里进行标记操作 */
[[MessageManager share] markMessage:baseModel completion:^(BOOL success) {
	// 刷新或显示UI
}];
baseModel._markImportant ^= 1;
```
###撤回消息
```
MessageBaseModel *model = [self.arrayDisplay objectAtIndex:indexPath.row];

[[MessageManager share] recallMessage:model completion:^(BOOL success) {
	// 刷新或显示UI     
}];
```
###合并及逐条转发
```
[[MessageManager share] forwardMergeMessages:<MessageBaseModel *>() // 待转发的消息 
                                           title:@"William Zhang 和 Andrew Shen的聊天记录"
                                         toUsers:@[@"ZBAYNbRqYAUBbjDE12", @"ZBAYNbRqYAUBbjDE14", @"ZBAYNbRqYAUBbjDE15"]	
                                         isMerge:YES  // 是否为合并转发
                                      completion:^(BOOL success)
    {
    	// 刷新或显示UI   
    }];
```
##好友体系
###添加好友
```
[[MessageManager share] addRelationValidateToUser:@"ZBAYNbRqYAUBbjDE14"
                                               remark:@"Andrew"
                                              content:@"你好，我是william"
                                      relationGroupId:-1
                                           completion:^(BOOL success)
     {
         // 刷新或显示UI
    }];
```
###搜索好友
```
[[MessageManager share] searchRelationUserWithRelationValue:searchBar.text completion:^(NSArray<MessageRelationInfoModel *> *array, BOOL success) {
        // 刷新或显示UI
    }];
```
###网络获取好友增量 
	
**新增totalFlag字段： false 增量 true 全量，默认是增量**

```
[[MessageManager share] loadRelationGroupInfoWithTotalFlag:NO Completion:^(BOOL success) 
{
        if (!success) {
            return;
        }
        
    	// 获取所有的分组
    	NSArray * groupListArray = [[MessageManager share] queryRelationGroups];
    
    	//获取所有好友数据
    	for (MessageRelationGroupModel *model in groupListArray)
   		{
        	NSArray *tempArray = [[MessageManager share] queryRelationInfoWithRelationGroup:model.relationGroupId];
	       [self.contactModelArray addObjectsFromArray:tempArray];
     	}
     	
     	// 刷新或显示UI
}];
```
###网络获取好友验证列表
```
[[MessageManager share] loadServerRelationValidateListCompletion:^(NSArray<MessageRelationValidateModel *> *validlist, BOOL success) {
        NSArray *reversedValidList = [[validlist reverseObjectEnumerator] allObjects];
        // 刷新或显示UI
    }];
```
###获取好友分组列表
```
NSArray *groupList = [[MessageManager share] queryRelationGroups];
```

###获取当前用户的好友分组
```
 [[MessageManager share] loadReLationGroupListcompletion:^(NSArray<MessageRelationInfoModel *> *array, BOOL success) {
        if (success)
        {
            NSArray *modelArray = array;
        }
  }];
    
```

###创建好友分组
```
[[MessageManager share] createRelationGroupWithName:@"group1" completion:^(MessageRelationGroupModel *model, BOOL success){
	// 刷新或显示UI
}];
```
###处理好友请求
```
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
[[MessageManager share] dealRelationWithModel:model validateState:3 relationGroupId:-1 remark:nil content:nil completion:^(BOOL isSuccess) {
        if (isSuccess) {
            // 刷新或显示UI
        }
   }];
```
###删除好友
```
[[MessageManager share] deleteRelationWithUid:@"ZBAYNbRqYAUBbjDE14"                                          									completion:^(BOOL isSuccess)
{
    if (!isSuccess) {
        return;
    }

    [[MessageManager share] removeSessionUid:@"ZBAYNbRqYAUBbjDE14" completion:^(BOOL isSuccess) {
        //删除本地数据里的好友数据
        [[MessageManager share] deleteRelationInfoWithRelationName:@"ZBAYNbRqYAUBbjDE14"];
        
		// 刷新或显示UI
    }];
}];
```
##移动好友分组
```
    [[MessageManager share] transferRelationWithRelationName:@"我的好友" RelationGroupID:0 completion:^(BOOL isSuccess) {
        if (isSuccess){
            //成功后回调操作
        }
    }];

```
##查询
```
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
/*
 * 查询某个会话中 ,缓存中的最新的消息是不是数据库中最新的
 * @param tager 会话唯一标示符 ,会话名称
 * @param 最新消息的msgid
 *
 */
- (BOOL)queryMessageIsNewestWithTagert:(NSString *)tagert msgid:(long long)msgid;
```
##登出
```
[[MessageMananger share] logout];
```