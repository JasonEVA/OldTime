//
//  CalendarNewEventTimeSelectView.h
//  launcher
//
//  Created by William Zhang on 15/7/31.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  新建📅候补时间选择器

#import <UIKit/UIKit.h>

/** 候补时间选择器状态 */
typedef NS_ENUM(NSUInteger, CalendarNewEventTimeSelectMode){
    /** 候补时间选择器带时分 */
    CalendarNewEventTimeSelectModeWithTime = 0,
    /** 候补时间选择器不带时分 */
    CalendarNewEventTimeSelectModeWholeDay,
};

@protocol CalendarNewEventTimeSelectViewDelegate <NSObject>

/** 选择成功后，返回时间 */
- (void)CalendarNewEventTimeSelectViewDelegateCallBack_SelectTimes:(NSArray *)timeArray selectMode:(CalendarNewEventTimeSelectMode)selectMode;

@end

@interface CalendarNewEventTimeSelectView : UIView

@property (nonatomic, weak) id<CalendarNewEventTimeSelectViewDelegate> delegate;

/**
 *  候补时间状态
 *
 *  @param mode     候补时间模式
 *  @param timeList 已存在时间（成双成对）
 *
 *  @return CalendarNewTimeSelectView
 */
- (instancetype)initWithMode:(CalendarNewEventTimeSelectMode)mode timeList:(NSArray *)timeList;

- (void)show;
- (void)dismiss;

@end
