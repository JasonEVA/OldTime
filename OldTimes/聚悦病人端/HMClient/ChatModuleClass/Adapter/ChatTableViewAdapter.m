//
//  ChatTableViewAdapter.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/8/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "ChatTableViewAdapter.h"

// 基本cell
#import "NewChatLeftAttachTableViewCell.h"
#import "NewChatLeftImageTableViewCell.h"
#import "NewChatLeftVoiceTableViewCell.h"
#import "NewChatLeftTextTableViewCell.h"
#import "NewChatRightAttachTableViewCell.h"
#import "NewChatRightImageTableViewCell.h"
#import "NewChatRightVoiceTableViewCell.h"
#import "NewChatRightTextTableViewCell.h"

// 扩展cell
#import "ChatShowDateTableViewCell.h"
#import "PatientServiceCommentLeftTableViewCell.h"
#import "PatientEventTableViewCell.h"
#import "PatientEventRightTableViewCell.h"
#import "PatientLeftWithTwoButtonTableViewCell.h"
#import "PatientServiceCommentRightTableViewCell.h"
#import "PatientDoubleChooseLeftTableViewCell.h"
#import "PatientHealthEducationLeftTableViewCell.h"
#import "PatientHealthEducationRightTableViewCell.h"
#import "PatientLeftNewVisitTableViewCell.h"

#import "LinkLabel.h"
#import "RMAudioManager.h"
#import "ChattingModule.h"
#import "IMNewsModel.h"

@interface ChatTableViewAdapter ()<ChatBaseTableViewCellDelegate,TTTAttributedLabelDelegate>

//@property (nonatomic, strong)  NSMutableArray  *arrayDisplay; // <##>
//@property (nonatomic, strong)  UserProfileModel  *targetProfile; // <##>
//@property (nonatomic, copy)  NSString  *strUid; // 用户Uid
/**
 *  存放上传图片进度的字典（_nativeOriginalUrl, 70%）
 */
@property (nonatomic, readonly) NSDictionary *uploadImageDictionary;
@property (nonatomic, assign)  BOOL  groupChat; // 是否是群聊
@property (nonatomic, strong)  ChattingModule  *chatModule; // 聊天数据类，TODO:
@property (nonatomic, copy)  NSString  *targetUid; // 聊天对象Uid

@end

@implementation ChatTableViewAdapter

#pragma mark - Interface Method


- (instancetype)initWithTargetUid:(NSString *)targetUid chattingModule:(ChattingModule *)module {
    self = [super init];
    if (self) {
        [self configTargetUid:targetUid chattingModule:module];
    }
    return self;

}

- (instancetype)init {
    return [self initWithTargetUid:@"" chattingModule:nil];
}

- (void)configTargetUid:(NSString *)targetUid chattingModule:(ChattingModule *)module {
    NSAssert(module, @"chatingModule不能为nil");
    _targetUid = targetUid;
    _groupChat = [targetUid hasSuffix:@"@ChatRoom"] || [targetUid hasSuffix:@"@SuperGroup"];
    _chatModule = module;
}

- (void)setCurrentPlayingVoiceMsgId:(long long)currentPlayingVoiceMsgId {
    long long playingMsgID = _currentPlayingVoiceMsgId;
    _currentPlayingVoiceMsgId = currentPlayingVoiceMsgId;
    // 刷新原来的播放的cell和现在要播放的cell
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF._msgId == %lld OR SELF._msgId == %lld",playingMsgID,currentPlayingVoiceMsgId];
    NSArray<MessageBaseModel *> *modelArray = [self.chatModule.showingMessages filteredArrayUsingPredicate:predicate];
    NSMutableArray *relodArray = [NSMutableArray arrayWithCapacity:modelArray.count];
    [modelArray enumerateObjectsUsingBlock:^(MessageBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSUInteger row = [self.chatModule.showingMessages indexOfObject:obj];
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:row inSection:0];
        [relodArray addObject:indexpath];
    }];
    [self.tableView reloadRowsAtIndexPaths:relodArray withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatModule.showingMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageBaseModel *messageModel = self.chatModule.showingMessages[indexPath.row];
    UserProfileModel *senderProfile;
    if (self.groupChat) {
        UserProfileModel *infoModelTemp = [[MessageManager share] queryContactProfileWithUid:[messageModel getUserName]];
        if (!infoModelTemp) {
            // 群里发送者信息从群信息里拿
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName == %@",[messageModel getUserName]];
            NSArray *filtedArray = [self.chatModule.targetProfile.memberList filteredArrayUsingPredicate:predicate];
            if (filtedArray.count > 0) {
                infoModelTemp = filtedArray.firstObject;
            }
        }
        senderProfile = infoModelTemp;
    }
    else {
        senderProfile = self.chatModule.targetProfile;
    }
    
    if (messageModel._type == msg_usefulMsgMin) {
        return [tableView dequeueReusableCellWithIdentifier:wz_default_tableViewCell_identifier];
    }
        
    if (![messageModel._toLoginName isEqualToString:self.targetUid])
    {
        // 发的人的名字
        NSString *nickName = [messageModel getNickName];
        
        // 发的人的uid
        NSString *userName = [messageModel getUserName];
        
        switch (messageModel._type)
        {
            case msg_personal_text:
            {
                NewChatLeftTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewChatLeftTextTableViewCell identifier]];
                cell.messageLabel.delegate = self.cellDelegate;
                [cell setDelegate:self.cellDelegate];
                [cell showTextMessage:messageModel];
                [cell setHeadIconWithUid:userName];
                [cell setRealName:nickName hidden:self.hideName];
                [cell setData:messageModel];
                [cell setEmphasisIsShow:messageModel._markImportant];
                
                // 回执消息
                UserInfo *info = [UserInfoHelper defaultHelper].currentUserInfo;
                NSDictionary *infoDict = [NSDictionary JSONValue:messageModel._info];
                if (infoDict[@"readUsers"] && [infoDict[@"readUsers"] isKindOfClass:[NSArray class]] && [infoDict[@"readUsers"] count] && [infoDict[@"readUsers"] containsObject:[NSString stringWithFormat:@"%ld",(long)info.userId]] && !messageModel._markReaded) {
                    // 未读状态调用接口
                    [self postReadedReceiptDelegateWithModel:messageModel];
                }

                return cell;
                break;
            }
                
            case msg_personal_voice:
            {
                NewChatLeftVoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewChatLeftVoiceTableViewCell identifier]];
                [cell setHeadIconWithUid:userName];
                // 计算音频长度
                CGFloat length = messageModel.attachModel.audioLength;
                [cell showVoiceMessageTime:length unreadMark:messageModel._markReaded];
                [cell setRealName:nickName hidden:self.hideName];
                [cell setData:messageModel];
                [cell setEmphasisIsShow:messageModel._markImportant];
                [cell setDelegate:self.cellDelegate];
                
                // 判断是否需要播放动画
                if (self.currentPlayingVoiceMsgId == messageModel._msgId) {
                    [cell startPlayVoiceWithTime:length];
                }
                else {
                    [cell stopPlayVoice];
                }
                
                return cell;
                break;
            }
                
                
            case msg_personal_image:
            {
                NewChatLeftImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewChatLeftImageTableViewCell identifier]];
                [cell setHeadIconWithUid:userName];
                [cell setRealName:nickName hidden:self.hideName];
                [cell setData:messageModel];
                [cell showSendImageMessageBaseModel:messageModel];
                [cell setEmphasisIsShow:messageModel._markImportant];
                [cell setDelegate:self.cellDelegate];
                return cell;
                break;
            }
                
                
            case msg_personal_file:
            {
                // 生成附件图片
                NewChatLeftAttachTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewChatLeftAttachTableViewCell identifier]];
                [cell setHeadIconWithUid:userName];
                [cell setRealName:nickName hidden:self.hideName];
                [cell setData:messageModel];
                [cell setEmphasisIsShow:messageModel._markImportant];
                [cell setAttachmentData:messageModel.attachModel];
                [cell setDelegate:self.cellDelegate];
                return cell;
                break;
            }

            case msg_personal_event:
            {
                //自定义消息
                NSString* content = messageModel._content;
                NSLog(@"自定义消息 %@", content);
                if (!content || 0 == content.length) {
                    break;
                }
                NSDictionary* dicContent = [NSDictionary JSONValue:content];
                if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
                {
                    break;
                }
                MessageBaseModelContent* modelContent = [MessageBaseModelContent mj_objectWithKeyValues:dicContent];
                NSString* contentType = modelContent.type;
                NSLog(@"contentType = %@", contentType);
                if (!contentType || 0 == contentType.length)
                {
                    break;
                    
                }
                
                if ([contentType isEqualToString:@"serviceComments"])
                {
                    //服务评价消息
                    
                    PatientServiceCommentLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PatientServiceCommentLeftTableViewCell identifier]];
                    [cell setHeadIconWithUid:userName];
                    [cell setRealName:nickName hidden:NO];
                    [cell setData:messageModel];
                    [cell setEmphasisIsShow:messageModel._markImportant];
                    //[cell setAttachmentData:messageModel.attachModel];
                    [cell setDelegate:self.cellDelegate];
                    [cell fillInDadaWith:messageModel];
                    return cell;
                    
                    break;
                }
                else if ([contentType isEqualToString:@"testResultPage"]) {//监测预警
                    PatientLeftWithTwoButtonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PatientLeftWithTwoButtonTableViewCell identifier]];
                    [cell setHeadIconWithUid:userName];
                    [cell setRealName:nickName hidden:NO];
                    [cell setData:messageModel];
                    [cell setEmphasisIsShow:messageModel._markImportant];
                    [cell setDelegate:self.cellDelegate];
                    [cell fillInDataWith:messageModel];
                    __weak typeof(self) weakSelf = self;
                    
                    [cell btnClick:^(NSInteger tag) {
                        if (tag) {
                            //查看详情
                            NSLog(@"查看详情");
                            [weakSelf postCheckWarningDelegateWithModel:messageModel];
                        }
                        else {
                            //处理预警
                            NSLog(@"处理预警");
                            [weakSelf postDealWarningDelegateWithModel:messageModel];
                        }
                    }];
                    return cell;
                    
                    break;
                }
                else if ([contentType isEqualToString:@"roundsAsk"]) { //查房询问
                    PatientDoubleChooseLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PatientDoubleChooseLeftTableViewCell identifier]];
                    [cell setHeadIconWithUid:userName];
                    [cell setRealName:nickName hidden:NO];
                    [cell setData:messageModel];
                    [cell setEmphasisIsShow:messageModel._markImportant];
                    [cell setDelegate:self.cellDelegate];
                    [cell fillInDataWith:messageModel];
                    __weak typeof(self) weakSelf = self;
                    [cell btnClick:^(NSInteger tag) {
                        [weakSelf postDealWithPatientRoundsWithModel:messageModel tag:tag];
                    }];

                    return cell;
                    break;
                }
//                else if ([contentType isEqualToString:@"surveyPush"]||[contentType isEqualToString:@"survey"]||[contentType isEqualToString:@"surveyFilled"]||[contentType isEqualToString:@"surveyReply"]) { //随访
//                    
//                    PatientLeftNewVisitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PatientLeftNewVisitTableViewCell identifier]];
//                    [cell setHeadIconWithUid:userName];
//                    [cell setRealName:nickName hidden:NO];
//                    [cell setData:messageModel];
//                    [cell setEmphasisIsShow:messageModel._markImportant];
//                    [cell setDelegate:self.cellDelegate];
////                    [cell fillInDataWith:messageModel];
//                    
//                    return cell;
//                    break;
//                }

//                else if ([contentType isEqualToString:@"Text"]) { //查房已填写（强制解析为text）
//                    NewChatLeftTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewChatLeftTextTableViewCell identifier]];
//                    cell.messageLabel.delegate = self.cellDelegate;
//                    NSString *text = modelContent.msg;
//                    text = [text stringByReplacingOccurrencesOfString:@" " withString:@" "];
//                    [[cell messageLabel] setRichText:text atUserList:nil];
//
//                    [cell setHeadIconWithUid:userName];
//                    [cell setRealName:nickName hidden:self.hideName];
//                    [cell setData:messageModel];
//                    [cell setEmphasisIsShow:messageModel._markImportant];
//                    return cell;
//                    break;
//                }
                else {
                    //其他自定义消息，样式一样
                    PatientEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PatientEventTableViewCell identifier]];
                    [cell setHeadIconWithUid:userName];
                    [cell setRealName:nickName hidden:NO];
                    [cell setData:messageModel];
                    [cell setEmphasisIsShow:messageModel._markImportant];
                    //[cell setAttachmentData:messageModel.attachModel];
                    [cell setDelegate:self.cellDelegate];
                    [cell fillInDadaWith:messageModel];
                    return cell;
                    
                }
                break;
                
            }
                //图文消息
            case msg_personal_news: {
                NSString* content = messageModel._content;
                NSLog(@"自定义消息 %@", content);
                if (!content || 0 == content.length) {
                    break;
                }
                NSDictionary* dicContent = [NSDictionary JSONValue:content];
                if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
                {
                    break;
                }
                IMNewsModel* modelContent = [IMNewsModel mj_objectWithKeyValues:dicContent];
                
                PatientHealthEducationLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PatientHealthEducationLeftTableViewCell identifier]];
                [cell setHeadIconWithUid:userName];
                [cell setRealName:nickName hidden:NO];
                [cell setData:messageModel];
                [cell setEmphasisIsShow:messageModel._markImportant];
                [cell setDelegate:self.cellDelegate];
                [cell fillInDadaWith:modelContent];
                return cell;
                
                break;
            }

                //            case msg_personal_video:
                //            {
                //                ChatLeftVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chat_video_left_cell];
                //                if (!cell)
                //                {
                //                    cell = [[ChatLeftVideoTableViewCell alloc] initWithReuseIdentifier:chat_video_left_cell Target:self Action:@selector(cellClicked:) ActionHead:@selector(headPicClicked:) ActionLong:@selector(longGesture:)];
                //                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                //                }
                //                NSString *fullPath = [NSString stringWithFormat:@"%@%@",im_IP_http,self.messageModel.attachModel.thumbnail];
                //                [cell setHeadIconWithUrl:self.avatarPath];
                //                [cell showImageMessage:fullPath Tag:indexPath.row];
                //                return cell;
                //            }
                //
                //                break;
                
            default:
                break;
        }
    }
    else
    {
        switch (messageModel._type)
        {
            case msg_personal_text:
            {
                NewChatRightTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewChatRightTextTableViewCell identifier]];
                cell.messageLabel.delegate = self.cellDelegate;
                [cell setDelegate:self.cellDelegate];
                [cell showTextMessage:messageModel];
                [cell setData:messageModel];
                [cell showStatus:messageModel._markStatus];
                [cell setEmphasisIsShow:messageModel._markImportant];
                __weak typeof(self) weakSelf = self;
                [cell setSendAgain:^() {
                    [weakSelf postResendMessageDelegateWithModel:messageModel];
                }];
                return cell;
                break;
            }
                
            case msg_personal_voice:
            {
                NewChatRightVoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewChatRightVoiceTableViewCell identifier]];
                CGFloat length = 0;
                if (messageModel._nativeOriginalUrl.length == 0)
                {
                    length = messageModel.attachModel.audioLength;
                }
                else
                {
                    // 计算音频长度
                    length = [RMAudioManager calculateAudioDurationWithPath:[[MsgFilePathMgr share] getAllPathWithRelativePath:messageModel._nativeOriginalUrl]];
                }
                
                [cell showVoiceMessageTime:length];
                [cell showStatus:messageModel._markStatus];
                [cell setData:messageModel];
                [cell setEmphasisIsShow:messageModel._markImportant];
                [cell setDelegate:self.cellDelegate];
                
                // 判断是否需要播放动画
                if (self.currentPlayingVoiceMsgId == messageModel._msgId) {
                    [cell startPlayVoiceWithTime:length];
                } else {
                    [cell stopPlayVoice];
                }
                __weak typeof(self) weakSelf = self;
                [cell setSendAgain:^() {
                    [weakSelf postResendMessageDelegateWithModel:messageModel];
                }];
                
                return cell;
                break;
            }
                
                
            case msg_personal_image:
            {
                NewChatRightImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewChatRightImageTableViewCell identifier]];
                [cell setData:messageModel];
                [cell showStatus:messageModel._markStatus progress:[self.uploadImageDictionary objectForKey:messageModel._nativeOriginalUrl]];
                [cell showSendImageMessage:messageModel];
                [cell setEmphasisIsShow:messageModel._markImportant];
                [cell setDelegate:self.cellDelegate];
                
                __weak typeof(self) weakSelf = self;
                [cell setSendAgain:^() {
                    [weakSelf postResendMessageDelegateWithModel:messageModel];
                }];
                
                return cell;
            }
                
                break;
            case msg_personal_event:
            {
                //自定义消息
                NSString* content = messageModel._content;
                NSLog(@"自定义消息 %@", content);
                if (!content || 0 == content.length) {
                    break;
                }
                NSDictionary* dicContent = [NSDictionary JSONValue:content];
                if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
                {
                    break;
                }
                MessageBaseModelContent* modelContent = [MessageBaseModelContent mj_objectWithKeyValues:dicContent];
                NSString* contentType = modelContent.type;
                NSLog(@"contentType = %@", contentType);
                if (!contentType || 0 == contentType.length)
                {
                    break;
                    
                }
                if ([contentType isEqualToString:@"serviceComments"])
                {
                    //右侧服务评价消息
                    
                    PatientServiceCommentRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PatientServiceCommentRightTableViewCell identifier]];
                    //                    [cell setHeadIconWithUid:userName];
                    //                    [cell setRealName:nickName hidden:NO];
                    [cell setData:messageModel];
                    [cell setEmphasisIsShow:messageModel._markImportant];
                    //                    [cell configCellDataWithProfile:senderProfile];
                    //[cell setAttachmentData:messageModel.attachModel];
                    [cell setDelegate:self.cellDelegate];
                    [cell fillInDadaWith:messageModel];
                    return cell;
                    
                    break;
                }
                else {
                    //其他event消息
                    PatientEventRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PatientEventRightTableViewCell identifier]];
                    [cell fillInDadaWith:messageModel];
                    //[cell setData:messageModel];
                    //                                    [cell showStatus:messageModel._markStatus progress:[self.uploadImageDictionary objectForKey:messageModel._nativeOriginalUrl]];
                    //                                    [cell showSendImageMessage:messageModel];
                    //[cell setEmphasisIsShow:messageModel._markImportant];
                    [cell setDelegate:self.cellDelegate];
                    return cell;
                }
                break;
            }
                
                //            case msg_personal_video:
                //            {
                //                ChatRightVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chat_video_right_cell];
                //                if (!cell)
                //                {
                //                    cell = [[ChatRightVideoTableViewCell alloc] initWithReuseIdentifier:chat_video_right_cell HeadIcon:self.myAvatarPath Target:self ActionTap:@selector(cellClicked:) ActionLong:nil ActionFail:@selector(failTapGesture:) ActionHead:nil];
                //                    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                //                }
                //
                //                [cell showStatus:self.messageModel._markStatus];
                //                [cell showSendImageMessageBaseModel:self.messageModel Tag:indexPath.row];
                //
                //                [cell showStatus:self.messageModel._markStatus];
                //                [cell setTag:indexPath.row];
                //                return cell;
                //            }
                //                break;
                
            case msg_personal_file:
            {
                // 生成附件图片
                NewChatRightAttachTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NewChatRightAttachTableViewCell identifier]];
                [cell showStatus:messageModel._markStatus];
                [cell setData:messageModel];
                [cell setEmphasisIsShow:messageModel._markImportant];
                [cell setAttachmentData:messageModel.attachModel];
                [cell setDelegate:self.cellDelegate];
                
                __weak typeof(self) weakSelf = self;
                [cell setSendAgain:^() {
                    [weakSelf postResendMessageDelegateWithModel:messageModel];
                }];
                
                return cell;
                break;
            }
                //图文消息
            case msg_personal_news: {
                NSString* content = messageModel._content;
                NSLog(@"自定义消息 %@", content);
                if (!content || 0 == content.length) {
                    break;
                }
                NSDictionary* dicContent = [NSDictionary JSONValue:content];
                if (!dicContent || ![dicContent isKindOfClass:[NSDictionary class]])
                {
                    break;
                }
                IMNewsModel* modelContent = [IMNewsModel mj_objectWithKeyValues:dicContent];
                
                PatientHealthEducationRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PatientHealthEducationRightTableViewCell identifier]];
                [cell setData:messageModel];
                [cell setEmphasisIsShow:messageModel._markImportant];
                [cell setDelegate:self.cellDelegate];
                [cell fillInDadaWith:modelContent];
                return cell;
                
                break;
            }

            default:
                break;
        }
        
    }
    
    // default
    ChatShowDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ChatShowDateTableViewCell identifier]];
    [cell showDateAndEvent:messageModel ifEvent:NO];
    return cell;
}

#pragma mark - Private Method

// 重发消息委托
- (void)postResendMessageDelegateWithModel:(MessageBaseModel *)model {
    if ([self.adapterDelegate respondsToSelector:@selector(chatTableViewAdapterDelegateCallBack_adapter:resendMessageWithModel:)]) {
        [self.adapterDelegate chatTableViewAdapterDelegateCallBack_adapter:self resendMessageWithModel:model];
    }
}

// 查看预警详情委托
- (void)postCheckWarningDelegateWithModel:(MessageBaseModel *)model {
    if ([self.adapterDelegate respondsToSelector:@selector(chatTableViewAdapterDelegateCallBack_adapter:patientChatCheckWarningDetailWithModel:)]) {
        [self.adapterDelegate chatTableViewAdapterDelegateCallBack_adapter:self patientChatCheckWarningDetailWithModel:model];
    }
}

// 处理预警委托
- (void)postDealWarningDelegateWithModel:(MessageBaseModel *)model {
    if ([self.adapterDelegate respondsToSelector:@selector(chatTableViewAdapterDelegateCallBack_adapter:patientChatDealWarningWithModel:)]) {
        [self.adapterDelegate chatTableViewAdapterDelegateCallBack_adapter:self patientChatDealWarningWithModel:model];
    }
}
//查房问询反馈
- (void)postDealWithPatientRoundsWithModel:(MessageBaseModel *)model tag:(NSInteger)tag{
    if ([self.adapterDelegate respondsToSelector:@selector(chatTableViewAdapterDelegateCallBack_adapter:patientChatDealPatientRoundsWithModel:tag:)]) {
        [self.adapterDelegate chatTableViewAdapterDelegateCallBack_adapter:self patientChatDealPatientRoundsWithModel:model tag:tag];
    }
}

// 回执消息已读
- (void)postReadedReceiptDelegateWithModel:(MessageBaseModel *)model {
    if ([self.adapterDelegate respondsToSelector:@selector(chatTableViewAdapterDelegateCallBack_adapter:patientChatReadedReceiptWithModel:)]) {
        [self.adapterDelegate chatTableViewAdapterDelegateCallBack_adapter:self patientChatReadedReceiptWithModel:model];
    }
}
#pragma mark - Init

- (NSDictionary *)uploadImageDictionary {
    return [MessageManager share].attachUploadProgressDictionary;
}

@end
