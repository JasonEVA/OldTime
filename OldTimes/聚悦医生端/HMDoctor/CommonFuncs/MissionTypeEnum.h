//
//  MissionTypeEnum.h
//  HMDoctor
//
//  Created by jasonwang on 16/5/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {  //任务类型枚举
    MissionType_Today = 0,        // 今天
    MissionType_Tomorrow = 1,        //明天
    MissionType_All = 2,        //所有任务
    MissionType_Refuse = 3,        //我拒绝的
    MissionType_SendFromMe = 4,        //我发出的
    MissionType_Down = 5,           //已完成
    
} MissionType;

typedef NS_ENUM(NSInteger, TaskStatusType) {
    TaskStatusTypeAll = 9999, // 全部
    TaskStatusTypeDeleted = -99, // 逻辑删除
    TaskStatusTypeDisabled = -1, // 禁用/拒绝
    TaskStatusTypeNonActivated = 0, // 未激活
    TaskStatusTypeActivated= 1, // 激活/接受
    TaskStatusTypeExpired = 2, // 任务过期
    TaskStatusTypeDone = 3 // 完成
};

typedef NS_ENUM(NSUInteger, MissionTaskPriority) {
    MissionTaskPriorityNone = 0,
    MissionTaskPriorityLow,
    MissionTaskPriorityMid,
    MissionTaskPriorityHigh,
};

// 0:不提醒,100:当天,101:5分钟前,102:15分钟前,103:半小时前,104:一小时前,105:两小时前.106:一天前.107:两天前,108:一星期前
typedef NS_ENUM(NSUInteger, MissionTaskRemindType) {
    MissionTaskRemindTypeNone = 0,
    MissionTaskRemindTypeToday = 100,
    MissionTaskRemindType5Min,
    MissionTaskRemindType15Min,
    MissionTaskRemindTypeHalfHour,
    MissionTaskRemindType1Hour,
    MissionTaskRemindType2Hours,
    MissionTaskRemindType1Day,
    MissionTaskRemindType2Days,
    MissionTaskRemindType1Weak,
};

typedef NS_ENUM(NSUInteger, TaskCommentType) {
    TaskCommentTypeAll = 0,
    TaskCommentTypeComment,
    TaskCommentTypeOperations,
}; // 评论类型


@interface MissionTypeEnum : NSObject

@property (nonatomic,copy) NSArray *titels;

- (NSString *)getTitelWithMissionType:(MissionType)type;
+ (NSString *)getTitelWithMissionTaskRemindType:(MissionTaskRemindType)type;
@end
