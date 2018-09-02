//
//  NewCalendarMeetingDetailCell.h
//  launcher
//
//  Created by kylehe on 16/5/27.
//  Copyright © 2016年 William Zhang. All rights reserved.
// 日程冲突详情 － 列表cell

#import <UIKit/UIKit.h>
@class CalendarLaunchrModel;
@interface NewCalendarMeetingDetailCell : UITableViewCell

+(NSString *)identifier;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setDateWithModel:(CalendarLaunchrModel *)model;
@end
