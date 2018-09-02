//
//  ChatIMConfigure.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/8/5.
//  Copyright © 2016年 yinquan. All rights reserved.
//  应用地址配置

#import <Foundation/Foundation.h>

#define ADDNEWFRIEND_TARGET @"Relation@SYS" //好友验证target标示

extern NSString * const im_IP_http;
extern NSString * const im_IP_ws;
extern NSString * const im_IP_test;

extern NSString * const im_appName;
extern NSString * const im_appToken;

extern NSString * const im_doctorPatientGroupTag; // 医患群聊天tag
extern NSString * const im_workGroupTag; // 医生群聊天tag

typedef NS_ENUM(NSUInteger, IMChatType) {
    IMChatTypeDefault,
    IMChatTypePatientChat,  // 医患聊天
    IMChatTypeWorkGroup,    // 工作组聊天
    IMChatTypeCustomerService,    // 客服
};
