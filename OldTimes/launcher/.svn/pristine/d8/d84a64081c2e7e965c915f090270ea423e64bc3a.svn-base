//
//  MeetingAddNewMeetingViewController.h
//  launcher
//
//  Created by Conan Ma on 15/8/6.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
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

@interface MeetingAddNewMeetingViewController: BaseViewController
{    
    BOOL _tempMust;                 // 是否必须参加
}
//测试数据
@property (nonatomic, strong) NSMutableArray *arrNameList;
@property (nonatomic) BOOL ViewNeedShow;

/** 事件信息 */
@property (nonatomic, assign) meeting_eventType eventType;

// 编辑的时候传入Model
- (void)setModel:(NewMeetingModel *)model;
- (void)setOriginalRepeatType:(calendar_repeatType)RepeatType;

@end
