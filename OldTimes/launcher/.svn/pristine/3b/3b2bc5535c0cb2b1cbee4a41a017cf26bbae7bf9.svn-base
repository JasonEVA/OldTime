//
//  NewCalendarAddMeetingViewController.h
//  launcher
//
//  Created by 马晓波 on 16/3/9.
//  Copyright © 2016年 William Zhang. All rights reserved.
//

#import "BaseViewController.h"
#import "MeetingAddNewMenberTableViewCell.h"
#import "MeetingTextFieldTableViewCell.h"
#import "MeetIngTextViewTableViewCell.h"
#import "MeetingTimeAndAddressWithoutMapTableViewCell.h"
#import "NewMeetingModel.h"

/** 会议类型 */
typedef NS_ENUM(NSUInteger, meeting_eventType)
{
    /** 正常新建保存 */
    meeting_eventTypeSave = 0,
    /** 编辑模式 */
    meeting_eventTypeEdit,
};
typedef void(^NewCalendarAddMeetingViewControllerBlock)();

@interface NewCalendarAddMeetingViewController : BaseViewController
{
    BOOL _tempMust;                 // 是否必须参加
}
//测试数据
@property (nonatomic, strong) NSMutableArray *arrNameList;
@property (nonatomic) BOOL ViewNeedShow;

/** 事件信息 */
@property (nonatomic, assign) meeting_eventType eventType;
/** 弹出方式 */
@property (nonatomic, assign) BOOL isPresented;
//是否从快速入口进入
@property(nonatomic, assign) BOOL  isFromQuickStart;

// 编辑的时候传入Model
- (void)setModel:(NewMeetingModel *)model;
- (void)setOriginalRepeatType:(calendar_repeatType)RepeatType;
- (void)refreshDataBlick:(NewCalendarAddMeetingViewControllerBlock)block;

@end
