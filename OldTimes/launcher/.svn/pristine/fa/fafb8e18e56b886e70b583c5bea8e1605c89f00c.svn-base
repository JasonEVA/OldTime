//
//  CalendarEventMakeSureHeaderView.h
//  launcher
//
//  Created by William Zhang on 15/8/3.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  日历事件确认 headerView

#import <UIKit/UIKit.h>

@class CalendarLaunchrModel;

@interface CalendarEventMakeSureHeaderView : UIView
- (instancetype)initWithReadOnlyMode:(BOOL)readOnlyMode;

- (void)setDataWithModel:(CalendarLaunchrModel *)model;

/** 获取 */
- (void)getSelectIndexBlock:(void(^)(NSInteger))indexBlock;

- (void)clearSelectionBlock:(void(^)())block;

@end
