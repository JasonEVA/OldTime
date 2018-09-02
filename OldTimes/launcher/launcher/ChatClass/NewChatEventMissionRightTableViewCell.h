//
//  NewChatEventMissionRightTableViewCell.h
//  launcher
//
//  Created by 马晓波 on 16/3/22.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "ChatBaseTableViewCell.h"
#import <MintcodeIM/MintcodeIM.h>

@interface NewChatEventMissionRightTableViewCell : ChatBaseTableViewCell

- (void)setCellData:(MessageBaseModel *)model;

/// 查看详情
@property (nonatomic, copy) void (^showDetail)();
@end
