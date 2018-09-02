//
//  CalendarEventMakeSureTimeSelectView.h
//  launcher
//
//  Created by William Zhang on 15/8/3.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  时间确认候补时间 单条View

#import <UIKit/UIKit.h>

@class CalendarEventMakeSureTimeSelectView;

typedef void(^CalendarEvnetMakeSureTimeDidSelectBlock)(CalendarEventMakeSureTimeSelectView *selectedView);

@interface CalendarEventMakeSureTimeSelectView : UIView

/** 设置标题index */
@property (nonatomic, assign) NSInteger index;

/** 设置能否选择的状态 */
@property (nonatomic, assign) BOOL canSelect;

@property (nonatomic, assign) BOOL hideTitle;

- (void)startTime:(NSDate *)startTime endTime:(NSDate *)endTime wholeDay:(BOOL)wholeDay;

/** 选择状态 */
- (void)selectStauts:(BOOL)isSelect;
/** 隐藏底部分割 */
- (void)hideLine:(BOOL)hide;

- (void)didSelectBlock:(CalendarEvnetMakeSureTimeDidSelectBlock)block;


@end
