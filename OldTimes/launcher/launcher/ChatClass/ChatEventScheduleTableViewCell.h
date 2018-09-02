//
//  ChatEventScheduleTableViewCell.h
//  launcher
//
//  Created by jasonwang on 15/10/10.
//  Copyright © 2015年 William Zhang. All rights reserved.
//

#import "EventSuperTableViewCell.h"

@protocol ChatEventScheduleTableViewCellDelegate <NSObject>

- (void)ChatEventScheduleTableViewCellDelegateCallBack_btnAttendClicked:(BOOL)isAttend ShowId:(NSString *)showId;

@end

@interface ChatEventScheduleTableViewCell : EventSuperTableViewCell

@property (nonatomic, weak) id<ChatEventScheduleTableViewCellDelegate> delegate;

- (void)setCellData:(MessageBaseModel *)model;
+ (CGFloat)cellHeight;

@end
