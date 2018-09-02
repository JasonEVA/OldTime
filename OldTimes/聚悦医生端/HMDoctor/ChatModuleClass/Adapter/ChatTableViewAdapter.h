//
//  ChatTableViewAdapter.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/8/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//  聊天tableViewDataSource

#import <Foundation/Foundation.h>
#import "MenuImageView.h"

@class ChatTableViewAdapter,MessageBaseModel,ChattingModule;
@protocol ChatBaseTableViewCellDelegate,TTTAttributedLabelDelegate;

@protocol ChatTableViewAdapterDelegate <NSObject>


- (void)chatTableViewAdapterDelegateCallBack_adapter:(ChatTableViewAdapter *)adapter resendMessageWithModel:(MessageBaseModel *)baseModel;

@optional

// 病患聊天，查看详情
- (void)chatTableViewAdapterDelegateCallBack_adapter:(ChatTableViewAdapter *)adapter patientChatCheckWarningDetailWithModel:(MessageBaseModel *)baseModel;
// 处理预警
- (void)chatTableViewAdapterDelegateCallBack_adapter:(ChatTableViewAdapter *)adapter patientChatDealWarningWithModel:(MessageBaseModel *)baseModel;
// 查房问询反馈
- (void)chatTableViewAdapterDelegateCallBack_adapter:(ChatTableViewAdapter *)adapter patientChatDealPatientRoundsWithModel:(MessageBaseModel *)baseModel tag:(NSInteger)tag;
@end

@interface ChatTableViewAdapter : NSObject<UITableViewDataSource>

@property (nonatomic, weak)  id<ChatTableViewAdapterDelegate>  adapterDelegate; // <##>
@property (nonatomic, weak)  id<ChatBaseTableViewCellDelegate,TTTAttributedLabelDelegate>  cellDelegate; // <##>

@property (nonatomic, assign)  BOOL  hideName; // 是否隐藏发送者名字

@property (nonatomic, assign) long long currentPlayingVoiceMsgId; // 当前播放语音Model的msgID
@property (nonatomic, strong)  UITableView  *tableView; // <##>
- (instancetype)initWithTargetUid:(NSString *)targetUid chattingModule:(ChattingModule *)module NS_DESIGNATED_INITIALIZER;

- (void)configTargetUid:(NSString *)targetUid chattingModule:(ChattingModule *)module;

// 配置cell长按菜单
- (void)configCellLongPressActions:(WZImageShowMenu)showMenu;
@end
