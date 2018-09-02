//
//  NewSiteMessageDoctorCareModel.h
//  HMClient
//
//  Created by jasonwang on 2016/12/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//  站内信 医生关怀model

#import <Foundation/Foundation.h>

@interface NewSiteMessageDoctorCareModel : NSObject
@property (nonatomic, copy) NSString *type;  //类型
@property (nonatomic, copy) NSString *msg;   //消息体
@property (nonatomic, copy) NSString *msgTitle;   //标题
@property (nonatomic) NSInteger status;      //状态
@end

/*
{
    "business_code": "SUCCESS",
    "business_message": "操作成功!",
    "result": [
               {
                   "creatTime": "2017-01-16 14:20:22",
                   "doThing": "{\"nickName\":\"柳刚\",\"alertContent\":\"JasonWang，您好，现在是您的查房时间。请问您昨天有没有不适症状？\"}",
                   "msgContent": "{\"msgTitle\":\"[查房]\",\"recordId\":123446,\"moudleId\":10527,\"status\":0,\"staffUserId\":10301,\"userId\":10645,\"type\":\"roundsAsk\",\"msg\":\"JasonWang，您好，现在是您的查房时间。请问您昨天有没有不适症状？\"}",
                   "msgType": "Event",
                   "sourceId": "63760",
                   "sourceTable": "SURVEY_RECORD",
                   "timeStamp": 1484547622425,
                   "typeCode": "YSGH"
               },
               {
                   "creatTime": "2017-01-16 13:44:23",
                   "doThing": "{\"nickName\":\"柳刚\",\"alertContent\":\"JasonWang，您好，现在是您的查房时间。请问您昨天有没有不适症状？\"}",
                   "msgContent": "{\"msgTitle\":\"null\",\"recordId\":123384,\"moudleId\":10527,\"status\":0,\"staffUserId\":10301,\"userId\":10645,\"type\":\"roundsAsk\",\"msg\":\"JasonWang，您好，现在是您的查房时间。请问您昨天有没有不适症状？\"}",
                   "msgType": "Event",
                   "sourceId": "63760",
                   "sourceTable": "SURVEY_RECORD",
                   "timeStamp": 1484545463270,
                   "typeCode": "YSGH"
               }
               ]
}
*/
