//
//  SiteMessageLastMsgModel.h
//  HMClient
//
//  Created by jasonwang on 2017/1/16.
//  Copyright © 2017年 YinQ. All rights reserved.
//  新版站内信消息体model

#import <Foundation/Foundation.h>

@interface SiteMessageLastMsgModel : NSObject
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic) long long createTimestamp;
@property (nonatomic, copy) NSString *msgId;
@property (nonatomic, copy) NSString *msgType;
@property (nonatomic, copy) NSString *sourceId;
@property (nonatomic, copy) NSString *sourceTable;
@property (nonatomic, copy) NSString *typeCode;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic) long long userId;
@property (nonatomic, copy) NSString *doThing;
@property (nonatomic, copy) NSString *msgContent;

@end

// 公告 msgContent model
@interface SESiteMessageNoticModel : NSObject
@property (nonatomic, copy) NSString *notesId;
@property (nonatomic, copy) NSString *msgTitle;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *notesUrl;             //对应详情H5地址
@property (nonatomic, copy) NSString *picUrl;

@end


// 约诊 msgContent model
@interface SESiteMessageAppointmentModel : NSObject
@property (nonatomic, copy) NSString *appointTime;
@property (nonatomic, copy) NSString *msgTitle;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *appointAddr;             //地址
@property (nonatomic, copy) NSString *patientName;             //病人
@property (nonatomic) NSInteger appointId;
@property (nonatomic, copy) NSString *type;      //区分约诊类型  助手消息类型 appointing  约诊同意 appointAgree  约诊取消 appointCancel
@property (nonatomic) NSInteger status;

@end

// 用户入组 msgContent model
@interface SESiteMessageServiceOrderModel : NSObject
@property (nonatomic, copy) NSString *timeLimit;
@property (nonatomic, copy) NSString *msgTitle;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *registerTypeName;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *type;      //"awaitDispatch"//分配   "notifyDoctor"//入组提醒   notifyStopInWeek 服务到期
@property (nonatomic, copy) NSString *providerName;  // 提供者
@property (nonatomic, copy) NSString *teamName;
@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *endTime;
@end

// 健康计划 msgContent model
@interface SESiteMessageHealthPlanModel : NSObject
@property (nonatomic) NSInteger healthyPlanId;
@property (nonatomic) NSInteger userId;

@property (nonatomic, copy) NSString *msgTitle;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *healthPlanName;

@end

// 建档评估 msgContent model
@interface SESiteMessageEvaluationModel : NSObject
@property (nonatomic) NSInteger userId;
@property (nonatomic, copy) NSString *type;    //assessCreated
@property (nonatomic, copy) NSString *registerTypeName;
@property (nonatomic, copy) NSString *providerName;  // 提供者
@property (nonatomic, copy) NSString *productName;

@property (nonatomic, copy) NSString *msgTitle;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *assessmentReportId;

@end

// 用药建议 msgContent model
@interface SESiteMessageMedicineSuggestedModel : NSObject
@property (nonatomic) NSInteger userId;
@property (nonatomic, copy) NSString *type;    //SysMessage

@property (nonatomic, copy) NSString *msgTitle;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *endTime;

@end
