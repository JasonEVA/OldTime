//
//  CalendarNewEventViewController.h
//  launcher
//
//  Created by William Zhang on 15/7/30.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  日程新建日历界面

#import "BaseViewController.h"

@class CalendarLaunchrModel;

/** 日程类型 */
typedef NS_ENUM(NSUInteger, calendar_eventType)
{
    /** 正常新建保存 */
    calendar_eventTypeSave = 0,
    /** 编辑模式 */
    calendar_eventTypeEdit,
};

typedef enum{
    save_type_only = 0,
    save_type_all = 1,
}savetype;

@interface CalendarNewEventViewController : BaseViewController

@property (nonatomic, strong) CalendarLaunchrModel *modelCalendar;

/** 事件信息 */
@property (nonatomic, assign) calendar_eventType eventType;
@property (nonatomic) savetype saveType;

/**
 *  删除tryAction(聊天中创建日程)
 */
@property (nonatomic, assign) BOOL noDeleteTryAction;

@end