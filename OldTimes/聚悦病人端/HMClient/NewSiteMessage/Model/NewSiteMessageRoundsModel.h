//
//  NewSiteMessageRoundsModel.h
//  HMClient
//
//  Created by jasonwang on 2017/1/22.
//  Copyright © 2017年 YinQ. All rights reserved.
//  新版站内信 查房model

#import <Foundation/Foundation.h>

@interface NewSiteMessageRoundsModel : NSObject
@property (nonatomic, copy) NSString *type;  //类型
@property (nonatomic, copy) NSString *msg;   //消息体
@property (nonatomic, copy) NSString *msgTitle;   //标题
@property (nonatomic, copy) NSString *recordId;
@property (nonatomic) NSInteger status;
@property (nonatomic) NSInteger staffUserId;   //医生id
@property (nonatomic) NSInteger userId;   //病人id

@end

//{"msgTitle":"null","recordId":123384,"moudleId":10527,"status":0,"staffUserId":10301,"userId":10645,"type":"roundsAsk","msg":"JasonWang，您好，现在是您的查房时间。请问您昨天有没有不适症状？"}
