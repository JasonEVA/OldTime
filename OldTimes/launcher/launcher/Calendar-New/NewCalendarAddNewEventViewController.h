//
//  NewCalendarAddNewEventViewController.h
//  launcher
//
//  Created by 马晓波 on 16/3/8.
//  Copyright © 2016年 William Zhang. All rights reserved.
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

typedef void(^NewCalendarAddNewEventViewControllerBlick)();

@interface NewCalendarAddNewEventViewController : BaseViewController

@property (nonatomic, strong) CalendarLaunchrModel *modelCalendar;

/** 事件信息 */
@property (nonatomic, assign) calendar_eventType eventType;
@property (nonatomic) savetype saveType;
/** 弹出方式 */
@property (nonatomic, assign) BOOL isPresented;
/**
 *  删除tryAction(聊天中创建日程)
 */
@property (nonatomic, assign) BOOL noDeleteTryAction;
- (instancetype)initWithNSDate:(NSDate *)date;
- (void)refreshDataBlick:(NewCalendarAddNewEventViewControllerBlick)block;

@end
