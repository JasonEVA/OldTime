//
//  MsgDefine.h
//  PalmDoctorDR
//
//  Created by Remon Lv on 15/5/12.
//  Copyright (c) 2015年 Andrew Shen. All rights reserved.
//  IM宏定义

#ifndef PalmDoctorDR_MsgDefine_h
#define PalmDoctorDR_MsgDefine_h

#pragma mark - SQL Table
typedef enum
{
    table_min,
    
    table_msg,                 // 消息总表（包含了聊天消息）
    table_msgList,             // 消息列表（列表占位）
    table_msgContacts,         // 联系人列表
    table_max,
    
    //    class_tag_message = 100,           // 消息模块
    
} MsgTableTag;     // 表名

/// IM指令集合
typedef NS_ENUM(NSUInteger, Msg_cmd_type) {
    // 严格在20001到29999 ,与msg_type不能重复
    msg_cmd_cmd = 20001,
    msg_cmd_clear, // 以前的脏指令
    msg_cmd_read,
    msg_cmd_open,
    msg_cmd_mark,
    msg_cmd_cancelMark,
    msg_cmd_remove,
    msg_cmd_relation
};

static NSString *const MTWebsocketLogoutNotification = @"MTWebsocketLogoutNotification";

static NSString *const MTRelationTarget = @"Relation@SYS";

#pragma mark - Var

#define M_V_TimeOut                  10    // 请求超时
#define M_V_loginKeep_duration       60    // SOCKET轮询登录时间
#define M_V_SEND_TIMEOUT             30    // 发送消息超时的时间
#define M_V_LOGIN_TIMEOUT            10    // login/loginKeep无响应超时的时间
#define M_V_NetworkBad    @"网络很糟糕，上传终止"   // 默认appName

#pragma mark - Interface Property

#define M_I_action        @"action"
#define M_I_appName       @"appName"
#define M_I_userName      @"userName"
#define M_I_userToken     @"userToken"
#define M_I_msgId         @"msgId"

#define M_I_code          @"code"
#define M_I_message       @"message"
#define M_I_remain        @"remain"
#define M_I_msg           @"msg"
#define M_I_data          @"data"

#pragma mark - Notification

// 用于从 Dict 解析数据时使用
#define CHECK_TEMP_OBJECT_IF_NOT_NULL(a) (a != [NSNull null] && a != NULL)
#define CHECK_VALUE_INRANGE(value,min,max) ((value >= min) && (value <= max))

/* —————————————————————————— Print信息 ——————————————————————————-—— */
/********输出打印描述（依赖DEBUG开关，用于DAL）********/
#ifdef DEBUG
#define PRINT_JSON_OUTPUT(NSString) if (DEBUG) NSLog(@"%@:%@————\n%@",[self description],@"Output",NSString)
#else
#define PRINT_JSON_OUTPUT(NSString)
#endif

/********输入打印描述（依赖DEBUG开关，用于DAL）********/
#ifdef DEBUG
#define PRINT_JSON_INPUT(NSString,URL) if (DEBUG) NSLog(@"%@:%@————\n%@\n%@",[self description],@"Input",URL,NSString)
#else
#define PRINT_JSON_INPUT(NSString,URL)
#endif

/********打印方法（依赖DEBUG开关，用于方法设下日志锚点）********/
#ifdef DEBUG
#define PRINT_SELECTOR if (DEBUG) NSLog(@"%@——%@",[self description],NSStringFromSelector(_cmd))
#else
#define PRINT_SELECTOR
#endif


/********普通打印描述（依赖DEBUG开关）********/
#ifdef DEBUG
#define PRINT_STRING(NSString) if (DEBUG) NSLog(@"%@",NSString)
#else
#define PRINT_STRING(NSString)
#endif

/********自定义打印描述（依赖DEBUG开关）********/
#ifdef DEBUG
#define PRINT_STRING_DOUBLE(String1,String2) NSLog(@"%@%@",String1,String2)
#else
#define PRINT_STRING_DOUBLE(String1,String2)
#endif

#endif
