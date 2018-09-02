//
//  HMHistoryChatViewController.h
//  HMClient
//
//  Created by jasonwang on 2017/4/12.
//  Copyright © 2017年 YinQ. All rights reserved.
//  聊天历史查看页面

#import "HMBaseViewController.h"

@interface HMHistoryChatViewController : HMBaseViewController
/** 字符串形式的uid，用户查找数据 */
@property (nonatomic, copy) NSString *strUid;
/*  msgid  */
@property (nonatomic,assign) long long msgid;
/** 联系人姓名 */
@property (nonatomic, copy) NSString *strName;
/** 联系人路径 */
@property (nonatomic, copy) NSString *avatarPath;
/** 联系人职位 */
@property (nonatomic, copy) NSString *strDepartment;
//消息对应在数据库中的id
@property (nonatomic) long long sqlId;
/* 是否是群聊 -- 用来判断是否展示群组成员昵称 */
@property (nonatomic) BOOL  IsGroup;
@property (nonatomic, strong)  UITableView *tableView; // 聊天TableView

// 从某一条消息开始获取
- (instancetype)initFromSomeOneMessageWithMessageId:(long long)msgid strUid:(NSString *)strUid;

/**
 获取一段时间内的消息（如需获取全部历史消息 begainMsgid = 0 ，endMsgid = -1）

 @param strUid 会话的Uid
 @param begainMsgid 截取时间段最早消息的Msgid  不限制最早时间传 0
 @param endMsgid 截取时间段最晚消息的Msgid     获取最新消息传 -1
 @return 初始化方法
 */
- (instancetype)initMeaageListWithStrUid:(NSString *)strUid begainMsgid:(long long)begainMsgid endMsgid:(long long)endMsgid;
@end
