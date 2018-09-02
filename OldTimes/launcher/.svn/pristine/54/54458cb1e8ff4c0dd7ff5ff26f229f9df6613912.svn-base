//
//  NewCalendarWeekView.h
//  launcher
//
//  Created by williamzhang on 16/3/3.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  新版日程周视图

#import <UIKit/UIKit.h>

@class NewCalendarWeeksModel;

@protocol NewCalendarWeekViewDelegate <NSObject>

- (void)NewCalendarWeekView_ChangeStartDate:(NSString *)startDate endDate:(NSString *)endDate;
- (void)setIsToday:(BOOL)isToday;

- (void)NewCalendarWeekViewDidSelectModel:(NewCalendarWeeksModel *)model;

@end

@interface NewCalendarWeekView : UIView

@property (nonatomic,assign) id<NewCalendarWeekViewDelegate>  delegate;
@property (nonatomic,strong) NSString * logName;  // 获取 谁的 日程的 (默认登录帐号)
@property (nonatomic, copy, readonly) NSString *currentMonthTitle;
@property (nonatomic, copy, readonly) NSString *currentYearTitle;

// 设置 查看谁的日程(默认登录账号)
- (void)setLookCalendarUID:(NSString*)uid;
// 定位到今天
- (void)locationWithToday;

- (BOOL)isTodayVisible;
@end
