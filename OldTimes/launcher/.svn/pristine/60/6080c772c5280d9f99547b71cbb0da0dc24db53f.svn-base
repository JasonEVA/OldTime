//
//  NewMissionTimeSelectView.h
//  launcher
//
//  Created by jasonwang on 16/2/16.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  开始截止时间选择View

#import <UIKit/UIKit.h>

@class NewMissionTimeSelectView;

@protocol NewMissionTimeSelectViewDelegate <NSObject>

@optional
- (void)NewMissionTimeSelectView:(NewMissionTimeSelectView *)timeView didSelectDate:(NSDate *)date;
- (void)NewMissionTimeSelectViewDelegateCallBack_isWholeDay:(BOOL) isWholdDay;
- (void)NewMissionTimeSelectViewDelegateCallBack_closeDeadlineSwitch;

@end

@interface NewMissionTimeSelectView : UIView

@property (nonatomic, weak) id<NewMissionTimeSelectViewDelegate> delegate;

@property (nonatomic, assign) BOOL showWholeDayMode;

/// 主要用于快速创建任务时区分开始结束
@property (nonatomic, assign) NSUInteger task_identifier;


- (void)wholeDayIsOn:(BOOL)isOn;

//设置标题和某一天或不设置
- (void)setTitle:(NSString *)title noSelect:(NSString *)noSelect;
//设置最大最小日期
- (void)setMyMaxDate:(NSDate *)MaxDate MinDate:(NSDate *)MinDate;

- (void)setDate:(NSDate *)date;

@end