//
//  MissionDetailModel.h
//  HMDoctor
//
//  Created by jasonwang on 16/4/28.
//  Copyright © 2016年 yinquan. All rights reserved.
//  任务详情Model
//
#import <Foundation/Foundation.h>
#import "MissionListComponentModel.h"
#import "MissionTypeEnum.h"

typedef NS_ENUM(NSInteger, EVENT_TYPE)
{
//    k_Participator = 1,    // 1.参与者
//    k_Not_participator,    // 2.非参与者
//    k_StateChanged,        // 3.参与者状态变更
//    k_comment,             // 4.评论
//    k_Remind               // 5.任务提醒
    CreateTask_Creater = 1,  //新建任务（创建者）
    CreateTask_Accepter,     //新建任务（接受者）
    Accept_Creater,          //接受任务（创建者）
    Accept_Accepter,         //接受任务（接受者）
    Refuse_Creater,          //拒绝任务（创建者）
    Refuse_Accepter,         //拒绝任务（接受者）
    Finish_Creater,          //完成任务（创建者）
    Finish_Accepter,         //完成任务（接受者）
    Expired_Creater,         //任务过期（创建者）
    Expired_Accepter,        //任务过期（接受者）
    
    k_comment = 104,          //评论
    Notify                   //系统通知
};

@interface MissionDetailModel : NSObject

@property (nonatomic, copy)  NSString  *participatorName; // 任务参与者
@property (nonatomic, assign)  BOOL  hasAttachments;//是否包含附件 0没有 1有
@property (nonatomic, copy)  NSString  *attachmentsTitles; // //附件文件名,包含后缀 多个以|分割
@property (nonatomic, copy)  NSString  *attachmentsPath; // //附件地址 绝对地址 多个以|分割

@property (nonatomic, copy)  NSString  *teamID; // 团队ID
@property (nonatomic, assign)  BOOL  isStartAllDay;
@property (nonatomic, copy)  NSString  *patientsName;       // 患者姓名 多个以|分割
@property (nonatomic, copy)  NSString  *patientsID;         //患者id 多个以|分割
@property (nonatomic, assign)  BOOL  isEndAllDay;
@property (nonatomic, copy)  NSString  *createUserName;         //创建者
@property (nonatomic, copy)  NSString  *taskTitle;          //任务标题
@property (nonatomic, assign)  MissionTaskRemindType  remindType;       // 任务提醒，0:不提醒,100:当天,101:5分钟前,102:15分钟前,103:半小时前,104:一小时前,105:两小时前.106:一天前.107:两天前,108:一星期前
@property (nonatomic, copy)  NSString  *participatorID;     //任务参与者id
@property (nonatomic, assign)  MissionTaskPriority  taskPriority;     //任务优先级 0=无，1=低，2=中，3=高
@property (nonatomic, copy)  NSString  *endTime;            //任务结束时间
@property (nonatomic, copy)  NSString  *createUserID;       //创建者id
@property (nonatomic, assign)  NSInteger  taskType;         //任务类型 0=随访，1=监测，2=自定义
@property (nonatomic, copy)  NSString  *startTime;          //任务开始时间
@property (nonatomic, assign)  NSInteger  ID;
@property (nonatomic, copy)  NSString  *showID;             //任务id
@property (nonatomic, assign)  BOOL  isRemind;              //是否提醒
@property (nonatomic, assign)  NSInteger  taskLevel;        //任务层级   1=根任务,2=子任务
@property (nonatomic, assign)  BOOL  isComment;             //是否有评论,0=没有,1=有
@property (nonatomic, assign)  TaskStatusType  taskStatus;       //任务状态,All = 9999 全部 Deleted = -99 逻辑删除 Disabled = -1 禁用/拒绝 NonActivated = 0 未激活 Activated = 1 激活/接受 Expired = 2 任务过期 Done = 3 完成
@property (nonatomic, copy)  NSString  *lastUpdateTime;     //最后更新时间
@property (nonatomic, copy)  NSString  *createTime;         //创建时间
@property (nonatomic, copy) NSString *remark;               //备注

@property (nonatomic, assign)  BOOL  isSendFromMe;

@property (nonatomic) BOOL isMemberAccess;
@property (nonatomic, copy)  NSString  *pShowName;    //团队名称

@property (nonatomic, copy) NSString *t_user;       //用户ID
@property (nonatomic, copy) NSString *p_show_ids;   //团队标示结合

// IM消息内容
@property(nonatomic, assign) EVENT_TYPE  eventType;          //1.参与者 2.非参与者 3参与者状态变更 4.评论
@property(nonatomic, copy) NSString * cc;
@property(nonatomic, copy) NSString  *ccName;
@property(nonatomic, strong) NSMutableArray  *listModelArray; // 接受、拒绝等按钮model

@property (nonatomic, assign)  BOOL  isCopyTeam; // 是否抄送团队长

@property (nonatomic,assign) long long clientMsgId; // messageBaseModel时间
@property (nonatomic,assign) long long msgId; // messageBaseModel时间

@property(nonatomic, copy) NSString  *msgInfo;
@property(nonatomic, copy) NSString  *commentContent; // 评论内容

@property (nonatomic, copy)  NSString  *senderId; // 消息操作者ID
@property (nonatomic, copy)  NSString  *senderName; // 消息操作者名字
@property (nonatomic, strong) NSString *reason;    //拒绝理由

//数据区分需要
@property (nonatomic) BOOL isFromTeam;   //是否为服务群分类下的

@end
