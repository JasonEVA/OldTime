//
//  ChatRightBaseTableViewCell.h
//  launcher
//
//  Created by Lars Chen on 15/9/25.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "ChatBaseTableViewCell.h"
#import <MintcodeIMKit/MintcodeIMKit.h>

typedef void(^ChatSendAgain)();

@interface ChatRightBaseTableViewCell : ChatBaseTableViewCell

@property (nonatomic, strong) UILabel *lbTime;                                  // 时间

@property (nonatomic, copy) ChatSendAgain sendAgain;

// 设置状态
- (void)showStatus:(Msg_status)status;

- (void)setData:(MessageBaseModel *)model;

// 设置时间 群不需要已读未读
- (void)setDate:(MessageBaseModel *)model;

//设置重点标志(是否展示)
- (void)setEmphasisIsShow:(BOOL)IsShow;

/// 图片上传状态设置
- (void)showImageUploadStatus:(Msg_status)status;

@end
