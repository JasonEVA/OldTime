//
//  NewSiteMessageMessageTypeENUM.h
//  HMClient
//
//  Created by jasonwang on 2017/2/20.
//  Copyright © 2017年 YinQ. All rights reserved.
//  第二版站内信 类型枚举

#import <Foundation/Foundation.h>
// 站内信 分类type
typedef NS_ENUM(NSUInteger, SiteMessageSecondEditionType) {
    
    SiteMessageSecondEditionType_YSGH,               //医生关怀 YSGH
    
    SiteMessageSecondEditionType_JKNZ,               //健康闹钟 JKNZ
    
    SiteMessageSecondEditionType_WDYZ,               //我的约诊 WDYZ
    
    SiteMessageSecondEditionType_JKJH,               //健康计划 JKJH
    
    SiteMessageSecondEditionType_JKPG,               //健康评估 JKPG
    
    SiteMessageSecondEditionType_JKBG,               //健康报告 JKBG
    
    SiteMessageSecondEditionType_XTXX,               //系统消息 XTXX
    
    SiteMessageSecondEditionType_JKKT,               //健康课堂 JKKT
    
    SiteMessageSecondEditionType_UnknowType = 10000  //未知类型
    
};

//医生关怀 YSGH 消息type
typedef NS_ENUM(NSUInteger, NewSiteMessageYSGHType) {
    
    NewSiteMessageYSGHType_userCarePage,            //医生问候 userCarePage
    
    NewSiteMessageYSGHType_roundsAsk,               //查房 roundsAsk
    
    NewSiteMessageYSGHType_surveyPush,              //随访 surveyPush
    
    NewSiteMessageYSGHType_serviceComments,         //服务评价 serviceComments
    
    NewSiteMessageYSGHType_surveyReply,             //随访回复 surveyReply

    NewSiteMessageYSGHType_UnknowType = 10000       //未知类型
    
};

//健康闹钟 JKNZ 消息type
typedef NS_ENUM(NSUInteger, NewSiteMessageJKNZType) {
    
    NewSiteMessageJKNZType_reviewPush,              //复查提醒 reviewPush
    
    NewSiteMessageJKNZType_drugPush,                //用药提醒 drugPush
    
    NewSiteMessageJKNZType_healthTest,              //监测提醒 healthTest
        
    NewSiteMessageJKNZType_UnknowType = 10000       //未知类型
    
};

//我的约诊 WDYZ 消息type
typedef NS_ENUM(NSUInteger, NewSiteMessageWDYZType) {
    
    NewSiteMessageWDYZType_appointAgree,            //约诊通过 appointAgree
    
    NewSiteMessageWDYZType_appointRefuse,           //约诊失败 appointRefuse
    
    NewSiteMessageWDYZType_appointCancel,           //约诊取消 appointCancel
    
    NewSiteMessageWDYZType_appointChange,           //约诊变更 appointChange

    NewSiteMessageWDYZType_appointremind,           //约诊提醒 appointremind

    NewSiteMessageWDYZType_UnknowType = 10000       //未知类型
    
};
@interface NewSiteMessageMessageTypeENUM : NSObject

// 站内信 分类type 字符串类型转枚举类型
+ (SiteMessageSecondEditionType)acquireMessageTypeWithString:(NSString *)string;

// 医生关怀 YSGH 消息type 字符串类型转枚举类型
+ (NewSiteMessageYSGHType)acquireNewSiteMessageYSGHTypeWithString:(NSString *)string;

// 健康闹钟 JKNZ 消息type 字符串类型转枚举类型
+ (NewSiteMessageJKNZType)acquireNewSiteMessageJKNZTypeWithString:(NSString *)string;

// 我的约诊 WDYZ 消息type 字符串类型转枚举类型
+ (NewSiteMessageWDYZType)acquireNewSiteMessageWDYZTypeWithString:(NSString *)string;
@end
