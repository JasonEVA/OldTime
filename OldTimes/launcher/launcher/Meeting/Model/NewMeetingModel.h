//
//  NewMeetingModel.h
//  launcher
//
//  Created by Lars Chen on 15/8/22.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//  新增会议Model

#import <Foundation/Foundation.h>
#import "CalendarLaunchrModel.h"


@interface NewMeetingModel : NSObject
@property (nonatomic, copy)  NSString  *showID; // 会议ID
@property (nonatomic, copy) NSString *title;                  // 会议标题
@property (nonatomic, copy) NSString *content;                // 会议内容
@property (nonatomic) NSDate *startTime;
@property (nonatomic) NSDate *endTime;
@property (nonatomic, copy) NSString *rShowId;                // 会议室ID
@property (nonatomic, strong) PlaceModel *place;                
@property (nonatomic, copy) NSString *requireJoin;            // 必须参加人员
@property (nonatomic, copy) NSString *requireJoinName;
@property (nonatomic, copy) NSString *join;                   // 非必需参加人员
@property (nonatomic, copy) NSString *joinName;
@property (nonatomic, assign) BOOL isVisible;                 //是否仅自己可见
@property (nonatomic, assign) BOOL isCancel;
@property (nonatomic, copy) NSString *createUser;
@property (nonatomic, copy) NSString *createUserName;

/** 必须参加（MeetingJoinPersonModel） */
@property (nonatomic, strong) NSArray *arrRequireJoin;
/** 非必需参加（MeetingJoinPersonModel） */
@property (nonatomic, strong) NSArray *arrJoin;

@property (nonatomic, assign) calendar_repeatType repeatType;   // 重复类型
@property (nonatomic, assign) calendar_remindType remindType;   // 提醒方式
@property (nonatomic, strong) NSString *updatetype;             //只更新会议的重复类型 选填

// 返回
@property (nonatomic, strong) NSString *showName;               // 会议室名字

- (NSString *)repeatTypeString;
- (NSString *)remindTypeString;

- (instancetype)initWithDict:(NSDictionary *)dict;
- (void)initWithModel:(NewMeetingModel *)model;


// ************** 编辑新建 重写get、set **************//

- (void)removeAllAction;
- (void)refreshAction;

@property (nonatomic, copy  ) NSString            *try_title;
@property (nonatomic, copy  ) NSString            *try_content;
@property (nonatomic, strong) NSDate              *try_startTime;
@property (nonatomic, strong) NSDate              *try_endTime;
@property (nonatomic, copy  ) NSString            *try_rShowId;
@property (nonatomic, strong) PlaceModel          *try_place;
@property (nonatomic, copy  ) NSString            *try_requireJoin;
@property (nonatomic, copy  ) NSString            *try_requireJoinName;
@property (nonatomic, copy  ) NSString            *try_join;
@property (nonatomic, copy  ) NSString            *try_joinName;
@property (nonatomic, assign) calendar_repeatType try_repeatType;
@property (nonatomic, assign) calendar_remindType try_remindType;
@property (nonatomic, copy  ) NSString            *try_showName;
@property (nonatomic, assign) BOOL           try_isVisible;
// ************** 编辑新建 重写get、set **************//
- (void)setplaceNil;
@end
