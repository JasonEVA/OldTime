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
@end
