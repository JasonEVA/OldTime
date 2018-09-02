////
////  MessageBaseModel+missionModelTranslate.m
////  HMDoctor
////
////  Created by kylehe on 16/6/6.
////  Copyright © 2016年 yinquan. All rights reserved.
////  
//
//#import "MessageBaseModel+missionModelTranslate.h"
//#import <MintcodeIMKit/MintcodeIMKit.h>
////#import "MissionDetailModel.h"
//#import "MissionListComponentModel.h"
//static NSString * const  showID         = @"showID";
//static NSString * const  user           = @"user";
//static NSString * const  userName       = @"userName";
//static NSString * const  endTime        = @"endTime";
//static NSString * const  startTime      = @"startTime";
//static NSString * const  patient        = @"patient";
//static NSString * const  patientName    = @"patientName";
//static NSString * const  cc             = @"cc";
//static NSString * const  ccName         = @"ccName";
//static NSString * const  priority       = @"priority";
//static NSString * const  status         = @"status";
//static NSString * const  title          = @"title";
//static NSString * const  createUser     = @"createUser";
//
//static NSString * const  list           = @"list";
//static NSString * const  eventMsgType   = @"eventMsgType";      //1.参与者，2.非参与者.3参与者状态变更 4.评论 5.推送消息
//static NSString * const  createUserName = @"createUserName";
//
//static NSString * const  taskTitle      = @"taskTitle";
//static NSString * const  t_content        = @"content";
//static NSString * const  taskShowId     = @"taskShowId";
//
//static NSString * const msgInfo        = @"msgInfo";
//static NSString * const senderId        = @"senderId";
//static NSString * const senderName        = @"senderName";
//
//static NSString * const reason    =  @"reason";
//static NSString * const pShowName    =  @"pShowName";
//
//@implementation MessageBaseModel (missionModelTranslate)
//
//+ (MissionDetailModel *)getDetailModelWithContent:(MessageBaseModel *)baseModel
//{
//    MissionDetailModel *model = [[MissionDetailModel alloc] init];
//    NSString *content = baseModel._content;
//    NSDictionary *dict = [content mj_JSONObject];
//    model.showID = @"";
//    model.createTime = [NSString stringWithFormat:@"%lld",baseModel._msgId/1000];
//    model.clientMsgId = baseModel._clientMsgId;
//    model.msgId = baseModel._msgId;
//    
//    if ([dict objectForKey:endTime] != [NSNull null] && [dict objectForKey:endTime] != NULL)
//    {
//        model.endTime = [dict objectForKey:endTime];
//    }
//    
//    if ([dict objectForKey:startTime] != [NSNull null] && [dict objectForKey:startTime] != NULL)
//    {
//        model.startTime = [dict objectForKey:startTime];
//    }
//    
//    if ([dict objectForKey:patient] != [NSNull null] && [dict objectForKey:patient] != NULL)
//    {
//        model.patientsID = [dict objectForKey:patient];
//    }
//    
//    if ([dict objectForKey:patientName] != [NSNull null] && [dict objectForKey:patientName] != NULL)
//    {
//        model.patientsName = [dict objectForKey:patientName];
//    }
//    
//    if ([dict objectForKey:priority] != [NSNull null] && [dict objectForKey:priority] != NULL)
//    {
//        model.taskPriority = [[dict objectForKey:priority] integerValue];
//    }
//    
//    if ([dict objectForKey:eventMsgType] != [NSNull null] && [dict objectForKey:eventMsgType] != NULL)
//    {
//        model.eventType = [[dict objectForKey:eventMsgType] integerValue];
//    }
//    
//    if ([dict objectForKey:status] != [NSNull null] && [dict objectForKey:status] != NULL)
//    {
//        model.taskStatus = [[dict objectForKey:status] integerValue];
//    }
//    
//    if ([dict objectForKey:createUser] != [NSNull null] && [dict objectForKey:createUser] != NULL)
//    {
//        model.createUserID = [dict objectForKey:createUser];
//    }
//    
//    if ([dict objectForKey:createUserName] != [NSNull null] && [dict objectForKey:createUserName] != NULL)
//    {
//        model.createUserName = [dict objectForKey:createUserName];
//    }
//    
//    if ([dict objectForKey:title] != [NSNull null] && [dict objectForKey:title] != NULL)
//    {
//        model.taskTitle = [[dict objectForKey:title] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    }
//    
//    if ([dict objectForKey:cc] != [NSNull null] && [dict objectForKey:cc] != NULL)
//    {
//        model.cc = [dict objectForKey:cc];
//    }
//    
//    if ([dict objectForKey:ccName] != [NSNull null] && [dict objectForKey:ccName] != NULL)
//    {
//        model.ccName = [dict objectForKey:ccName];
//    }
//    
//    if ([dict objectForKey:taskTitle] != [NSNull null] && [dict objectForKey:taskTitle] != NULL)
//    {
//        model.taskTitle = [dict objectForKey:taskTitle];
//    }
//    
//    if (model.eventType == k_comment)
//    {
//        if ([dict objectForKey:taskShowId] != [NSNull null] && [dict objectForKey:taskShowId] != NULL)
//        {
//            model.showID = [dict objectForKey:taskShowId];
//        }
//    }else
//    {
//        if ([dict objectForKey:showID] != [NSNull null] && [dict objectForKey:showID] != NULL)
//        {
//            model.showID = [dict objectForKey:showID];
//        }
//    }
//
//    if ([dict objectForKey:t_content] != [NSNull null] && [dict objectForKey:t_content] != NULL)
//    {
//        model.commentContent = [dict objectForKey:t_content];
//    }
//    
//    if ([dict objectForKey:list] !=  [NSNull null] && [dict objectForKey:list] != NULL)
//    {
//        NSArray *arr = [dict objectForKey:list];
//        if (arr.count > 0)
//        {
//            NSMutableArray *modelArray = [NSMutableArray array];
//            for (NSDictionary *dic in [dict objectForKey:list])
//            {
//                [modelArray addObject:[[MissionListComponentModel alloc] initWithDict:dic]];
//            }
//            model.listModelArray = modelArray;
//        }
//    }
//    
//    if ([dict objectForKey:user] != [NSNull null] && [dict objectForKey:user] != NULL)
//    {
//        model.participatorID = [dict objectForKey:user];
//    }
//    
//    if ([dict objectForKey:userName] != [NSNull null] && [dict objectForKey:userName] != NULL)
//    {
//        model.participatorName = [dict objectForKey:userName];
//    }
//    if ([dict objectForKey:msgInfo] != [NSNull null] && [dict objectForKey:msgInfo] != NULL)
//    {
//        model.msgInfo = [dict objectForKey:msgInfo];
//    }
//
//    if ([dict objectForKey:senderId] != [NSNull null] && [dict objectForKey:senderId] != NULL)
//    {
//        model.senderId = [dict objectForKey:senderId];
//    }
//    if ([dict objectForKey:senderName] != [NSNull null] && [dict objectForKey:senderName] != NULL)
//    {
//        model.senderName = [dict objectForKey:senderName];
//    }
//    
//    if ([dict objectForKey:reason] != [NSNull null] && [dict objectForKey:reason] != NULL)
//    {
//        model.reason = [dict objectForKey:reason];
//    }
//    if ([dict objectForKey:pShowName] != [NSNull null] && [dict objectForKey:pShowName] != NULL)
//    {
//        model.pShowName = [dict objectForKey:pShowName];
//    }
//
//
//    return model;
//    
//}
//
//@end
