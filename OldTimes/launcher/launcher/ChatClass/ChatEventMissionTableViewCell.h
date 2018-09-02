//
//  ChatEventMissionTableViewCell.h
//  launcher
//
//  Created by jasonwang on 15/10/9.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "EventSuperTableViewCell.h"

@interface ChatEventMissionTableViewCell : EventSuperTableViewCell

+ (CGFloat)height;

- (void)setCellData:(MessageBaseModel *)model;

/// 查看详情
@property (nonatomic, copy) void (^showDetail)();

@end
