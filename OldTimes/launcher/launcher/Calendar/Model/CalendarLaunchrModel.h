//
//  CalendarLaunchrModel.h
//  launcher
//
//  Created by William Zhang on 15/8/20.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaceModel.h"

/** 重复类型 */
typedef NS_ENUM(NSUInteger, calendar_repeatType)
{
    calendar_repeatNo = 0,
    calendar_repeatDay,
    calendar_repeatWeak,
    calendar_repeatMonth,
    calendar_repeatYear
};

/** 提示方式 (MM分钟 HH小时。。。)*/
typedef NS_ENUM(NSUInteger, calendar_remindType)
{
    calendar_remindTypeEventNo = 0,
    calendar_remindTypeEventStart = 100,
    calendar_remindTypeFiveMM,
    calendar_remindTypeFifthMM,
    calendar_remindTypeThirtyMM,
    
    calendar_remindTypeOneHH,
    calendar_remindTypeTwoHH,
    
    calendar_remindTypeOneDay,
    calendar_remindTypeTwoDay,
    
    calendar_remindTypeOneWeek,
    
    calendar_remindTypeWholeDay = 200,
    
    calendar_remindTypeWholeOneDay,
    calendar_remindTypeWholeTwoDay,
    
    calendar_remindTypeWholeOneWeek
};

typedef enum{
    eventType_calendar_event = 0,
    eventType_meeting_event = 1,
    eventType_company_festival = 2,
    eventType_statutory_festival = 3,
}eventTpye;


@interface CalendarLaunchrModel : NSObject

/** 由服务器返回，新建日程为空 */
@property (nonatomic, copy) NSString *showId;

@property (nonatomic, copy) NSString *title;

/** 时间（成双成对出现，） */
@property (nonatomic, strong) NSMutableArray *time;

/** 事件 */
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) PlaceModel *place;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) BOOL important;
@property (nonatomic, assign) BOOL wholeDay;
@property (nonatomic, assign) BOOL Cancel;
@property (nonatomic, strong) NSString *relateId;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) calendar_repeatType repeatType;
@property (nonatomic, assign) calendar_remindType remindType;

@property (nonatomic, copy) NSString *createUser;
@property (nonatomic, copy) NSString *createUserName;

@property (nonatomic, assign) eventTpye eventType;
@property (nonatomic, assign) BOOL isVisible;
//仅用于排序
@property (nonatomic) BOOL isallday;


/** 列表获取 time的 showId */
@property (nonatomic, strong) NSMutableArray *showIdList;

+ (NSArray *)repeatArray;
+ (NSArray *)remindNumbersIsWholeDay:(BOOL)wholeDay;
+ (NSArray *)remindArrayWholeDay:(BOOL)wholeDay;

- (instancetype)initWithDict:(NSDictionary *)dict;
- (instancetype)initWithDayDict:(NSDictionary *)dict;


- (NSString *)repeatTypeString;
+ (NSString *)repeatTypeStringAtIndex:(NSInteger)index;
- (NSString *)remindTypeString;
+ (NSString *)remindTypeStringAtIndex:(NSInteger)index;
+ (NSString *)remindTypeStringAtIndex:(NSInteger)index wholeDay:(BOOL)wholeDay;

// ************** 编辑新建专用 get,set重写 **************//

- (void)removeTryAction;

@property (nonatomic, copy  ) NSString       *try_title;
@property (nonatomic, strong) NSMutableArray *try_time;
@property (nonatomic, strong) PlaceModel     *try_place;
@property (nonatomic, assign) BOOL           try_important;
@property (nonatomic, assign) BOOL           try_wholeDay;
@property (nonatomic, assign) BOOL           try_isVisible;
@property (nonatomic, strong) NSString       *try_content;

@property (nonatomic, assign) calendar_repeatType try_repeatType;
@property (nonatomic, assign) calendar_remindType try_remindType;

- (void)refreshAllAction;

// ************** 编辑新建专用 get,set重写 **************//

@end