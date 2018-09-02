//
//  HMDoctorEnum.h
//  HMDoctor
//
//  Created by jasonwang on 16/4/13.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#ifndef HMDoctorEnum_h
#define HMDoctorEnum_h
#import "MissionTypeEnum.h"
typedef NS_ENUM(NSUInteger, TitelType) { //加好友，创建工作圈，新建任务的枚举
    
    AddNewFriendType,
    
    CreateWorkCircle,
    
    AddNewMissionType
    
};

typedef NS_ENUM(NSUInteger, ConcernSendType) { //按人，按群
    
    SendToPatientsType,
    
    SendToGroupsType
    
};

// 医生关系类型
typedef NS_ENUM(NSUInteger, ContactRelationshipType) {
    ContactRelationshipType_friend, // 好友
    ContactRelationshipType_groupMember, // 非好友，但是是群成员
    ContactRelationshipType_stranger,   // 陌生人
    ContactRelationshipType_none,   // 只显示信息，其余功能不显示

};

//新建任务标题枚举
typedef NS_ENUM(NSUInteger, Cell_Type) {
    CellType_Title = 00,        // 标题
    CellType_Urgent,        // 加急
    CellType_Member,       // 参与者
    CellType_Patient,      // 患者
    
    CellType_StartTime = 10,    // 开始时间
    CellType_StartTimePicker,    // 开始时间
    CellType_Deadline,     // 截止时间
    CellType_DeadlineTimePicker,     // 截止时间选择器
    CellType_Alert,        // 提醒时间
    
    
//    CellType_AddToCalendar = 20,   // 添加到日程
    CellType_GroupTask = 20,     // 项目组任务
    CellType_Accessory,    // 附件
    
    CellType_Details = 30,      // 备注
    
    StartTimeIsWholeDay,   //开始时间是否是全天
    EndTimeIsWholeDay,     //结束时间是否是全天
};

//任务详情枚举
typedef NS_ENUM(NSUInteger, MissionDetailCell_Type) {
    MissionDetailCell_Type_Title = 00,        // 标题
    MissionDetailCell_Type_Member,        //参与人
    MissionDetailCell_Type_Patient,        //患者
    
    MissionDetailCell_Type_StartTime = 10,        // 开始时间
    MissionDetailCell_Type_EndTime,        // 结束时间
    MissionDetailCell_Type_Remind,        // 提醒时间
    
    MissionDetailCell_Type_Accessory = 20,    // 附件
    
    MissionDetailCell_Type_Detail = 30,        //备注
};


#endif /* HMDoctorEnum_h */
