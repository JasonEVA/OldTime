//
//  CalendarMakeSureDetailTableViewCell.h
//  launcher
//
//  Created by William Zhang on 15/8/3.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  日历 确认 详细 Cell

#import <UIKit/UIKit.h>
#import "RichTextConfigure.h"

@protocol CalendarMakeSureDetailTableViewCellDelegate <NSObject>
- (void)calendarMakeSureDetailTableViewCellDidClickRichText:(NSString *)text textType:(RichTextType)textType;
@end
@interface CalendarMakeSureDetailTableViewCell : UITableViewCell

@property (nonatomic, assign)id<CalendarMakeSureDetailTableViewCellDelegate> delegate;
+ (NSString *)identifier;
+ (CGFloat)heightForCell:(NSString *)text;

- (void)setDetailText:(NSString *)detailText;
- (void)setDetailText:(NSString *)detailText textColor:(UIColor *)textColor;
@end
