//
//  NewApplySwitchTableViewCell.h
//  launcher
//
//  Created by Dee on 16/8/10.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  Coustom_inputtype_Switch

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, CalendarSwitchType)
{
    CalendarSwitchTypeImportant = 0,
    CalendarSwitchTypeWholeDay = 1,
    CalendarSwitchTypeisVisible = 2
};

typedef void(^CalendarSwitchDidChangeBlock)(CalendarSwitchType swithType, BOOL);

@interface NewApplySwitchTableViewCell : UITableViewCell

/** switch颜色 */
@property (nonatomic, strong) UIColor *switchColor;
@property (nonatomic, assign) CalendarSwitchType switchType;

+ (NSString *)identifier;

- (void)calendarSwitchDidChange:(CalendarSwitchDidChangeBlock)block;

- (void)isOn:(BOOL)isOn;


@end
