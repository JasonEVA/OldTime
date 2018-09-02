//
//  ImApplicationConfigure.h
//  launcher
//
//  Created by williamzhang on 16/3/7.
//  Copyright © 2016年 William Zhang. All rights reserved.
//  聊天应用配置

#import <Foundation/Foundation.h>
#import <MintcodeIM/MintcodeIM.h>
#import "ChatIMConfigure.h"

extern NSString *const im_task_uid;
extern NSString *const im_approval_uid;
extern NSString *const im_schedule_uid;

typedef enum
{
    AppType_FromReceiver = 0,
    AppType_FromCC,
    AppType_Event,
    AppType_Meeting,
    AppType_S_Remind,
    AppType_M_Remind,
    AppType_T_Remind,
    AppType_EVENT_COMMENT,
    AppType_MEETING_COMMENT,
    AppType_APPROVAL_COMMENT
}MsgAppType;        // String 消息应用类型 EVENT   事件 EVENT_COMMENT  事件评论 MEETING   会议 MEETING_COMMENT  会议评论 APPROVE    审批 CC     抄送 SEND   发出 APPROVAL_COMMENT 审批的评论

typedef enum : NSUInteger {
    comment,                            // Name 在　Title　留下评论
    meetingAttend,                      // Name 确定参加
    meetingAttendDefinite,              // Title，Name确定参加
    meetingRefuseAttend,                // Name 拒绝参加
    meetingRefuseAttendDefinite,
    meetingCancel,
    meetingEdit,
    meetingCancelOne,
    approvePut,
    approvePost,
    approvePass,                        // Name 通过了 Title
    approveBack,                        // Name 打回了 Title
    approveBackV2,
    approveBackDefinite,                // Name 打回了 Title，reason
    approveRefuse,                      // Name 拒绝了 Title
    approveRefuseDefinite,              // Name 拒绝了 Title，reason
    approveTranspond,                   // Name 转交了 Title
    approveTranspondDefinite,           // Name 转交了 Title，reason
    taskDelete,                         // Name 删除了 Title
    taskEditStatus,                     // Name 修改了 Title的状态
    taskEditStatusDefinite,             // Name 修改任务状态为 Status
    remindSchedule,                     // Title将在Time开始
    remindTask,                         // Title将在Time结束
    remindTaskV2,                       // Title将在Time结束
    createTaskV2,                       //创建任务
    taskV2Update,                       //修改了任务内容
    taskV2ChangeStatus,
    taskV2ChangeDoneStatus,
    taskV2ChangeDoingStatus,
    //    taskV2ChangeStatus,                 //{name}修改了{title}的状态
    //    taskV2ChangeDoneStatus,             //修改任务状态为已完成
    //    taskV2ChangeDoingStatus             //修改任务状态为待处理
    
} MsgTransType;                         // 消息翻译类别

/*---- 审批的类型 ------*/
// PS: 现在没用了
typedef enum
{
    MsgApprovalType_askLeave = 0, // 请假
    MsgApprovalType_cost, // 费用
    MsgApprovalType_Other, // 其他
}MsgApprovalType;

@interface IMApplicationUtil : NSObject

// 获得消息应用类型 比如审批是审批人还是抄送人
+ (MsgAppType)getMsgAppTypeWith:(NSString *)msgAppString;

+ (MsgApprovalType)getMsgApprovalTypeWith:(NSString *)approvalShowID;

+ (MsgTransType)getMsgTransTypeWith:(NSString *)msgTransType;

// 获得系统消息文字    Example: Name 打回了 Title，reason
+ (NSString *)getMsgTextWithModel:(MessageAppModel *)model;

@end