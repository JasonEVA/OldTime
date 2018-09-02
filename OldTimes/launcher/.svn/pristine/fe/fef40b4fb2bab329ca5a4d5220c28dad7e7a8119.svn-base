//
//  CalendarSwitchTableViewCell.h
//  launcher
//
//  Created by William Zhang on 15/7/30.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  switch选择器

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CalendarSwitchType)
{
    CalendarSwitchTypeImportant = 0,
    CalendarSwitchTypeWholeDay = 1,
    CalendarSwitchTypeisVisible = 2
};

typedef void(^CalendarSwitchDidChangeBlock)(CalendarSwitchType swithType, BOOL);

@interface CalendarSwitchTableViewCell : UITableViewCell

/** switch颜色 */
@property (nonatomic, strong) UIColor *switchColor;
@property (nonatomic, assign) CalendarSwitchType switchType;

+ (NSString *)identifier;

- (void)calendarSwitchDidChange:(CalendarSwitchDidChangeBlock)block;

- (void)isOn:(BOOL)isOn;

@end
