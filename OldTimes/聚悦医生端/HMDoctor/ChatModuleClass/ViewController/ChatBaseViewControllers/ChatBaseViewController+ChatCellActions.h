//
//  ChatBaseViewController+ChatCellActions.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/8/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//  按钮点击事件

#import "ChatBaseViewController.h"

@interface ChatBaseViewController (ChatCellActions)<MWPhotoBrowserDelegate,ChatBaseTableViewCellDelegate>

- (void)voicePlayOrStopWithVoicePath:(NSString *)voicePath playVoiceMsgId:(long long)voiceMsgId;

- (void)cellClicked:(MessageBaseModel *)baseModel;

/** 重发消息*/
- (void)resendMessage:(MessageBaseModel *)baseModel;

//医患聊天图片收藏事件，由子类实现
- (void)at_patientDoctorChatCollectImageWithModel:(MessageBaseModel *)model;

//问诊和随访卡片点击事件，由子类实现
- (void)at_patientDoctorChatInquirySendWithDict:(NSDictionary *)dict;
@end
