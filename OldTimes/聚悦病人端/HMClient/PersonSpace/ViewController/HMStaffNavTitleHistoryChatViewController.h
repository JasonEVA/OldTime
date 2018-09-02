//
//  HMStaffNavTitleHistoryChatViewController.h
//  HMClient
//
//  Created by jasonwang on 2017/4/12.
//  Copyright © 2017年 YinQ. All rights reserved.
//  聊天历史查看页面带医生团队navview VC

#import "HMBaseViewController.h"
@class HMClientGroupChatModel;
@class HMConsultingRecordsModel;
@interface HMStaffNavTitleHistoryChatViewController : HMBaseViewController
- (instancetype)initWithChatModel:(HMClientGroupChatModel *)chatModel;

// 咨询记录入口
- (instancetype)initWithHMConsultingRecordsModel:(HMConsultingRecordsModel *)model;
@end
