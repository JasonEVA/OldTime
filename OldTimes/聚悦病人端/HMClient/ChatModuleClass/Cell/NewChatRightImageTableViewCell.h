//
//  NewChatRightImageTableViewCell.h
//  launcher
//
//  Created by Lars Chen on 15/9/25.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatRightBaseTableViewCell.h"

@interface NewChatRightImageTableViewCell : ChatRightBaseTableViewCell

// 显示图片（本地发送的）
- (void)showSendImageMessage:(MessageBaseModel *)baseModel;
// 显示位置截图
- (void)showPositionMessage:(UIImage *)image Tag:(NSInteger)tag;

/**
 *  发送状态
 *
 *  @param status   状态
 *  @param progress 发送百分比
 */
- (void)showStatus:(Msg_status)status progress:(NSNumber *)progress;

@end
