//
//  NewCalendarAlertView.h
//  launcher
//
//  Created by williamzhang on 16/3/3.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  新版日程多选择View

#import <UIKit/UIKit.h>

@class NewCalendarAlertView;

@protocol NewCalendarAlertViewDelegate <NSObject>

- (void)newCalendarAlertView:(NewCalendarAlertView *)alertView didClickedAtIndex:(NSUInteger)index;

@end

@interface NewCalendarAlertView : UIView

@property (nonatomic, weak) id<NewCalendarAlertViewDelegate> delegate;

- (instancetype)initWithImages:(NSArray *)images titles:(NSArray *)titles;
- (instancetype)initWithImages:(NSArray *)images selectImages:(NSArray *)selectImages titles:(NSArray *)titles;

- (void)setSelectedIndex:(NSUInteger)index;
- (void)setToday:(BOOL)isToday;
- (void)lookOthersScheduleWithName:(NSString *)name;


@end
