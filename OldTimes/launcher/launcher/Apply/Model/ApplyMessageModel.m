//
//  ApplyMessageModel.m
//  launcher
//
//  Created by Conan Ma on 15/9/16.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import "ApplyMessageModel.h"
#import "NSDictionary+SafeManager.h"

static NSString *const showID = @"showID";              //消息的ShowID
static NSString *const from = @"from";                //发送人
static NSString *const from_Name = @"from_Name";           //发送人姓名
static NSString *const to = @"to";                  //接收人
static NSString *const to_Name = @"to_Name";             //接收人姓名
static NSString *const title = @"title";               //标题
static NSString *const content = @"content";             //内容
static NSString *const type = @"type";                        //消息类型，1代表业务消息，0代表系统消息
static NSString *const appMessageType = @"appMessageType";      //消息应用类型，暂时有MEETING-会议，EVENT-事件，APPROVE-审批，CC-抄送，SEND-发出
static NSString *const remark = @"remark";              //备注
static NSString *const statusTime = @"statusTime";                  //更改时间
static NSString *const appShowID = @"appShowID";           //应用ShowID
static NSString *const rmShowID = @"rmShowID";            //关联主键
static NSString *const readStatus = @"readStatus";                  //是否已读，1代表已读，0代表未读
static NSString *const handleStatus = @"handleStatus";                //是否已处理，1代表已处理，0代表未处理
static NSString *const createTime = @"createTime";                  //创建时间
static NSString *const createUser = @"createUser";          //创建人
static NSString *const createUserName = @"createUserName";      //创建人姓名


@implementation ApplyMessageModel
- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if (dict)
        {
            self.showID = [dict valueStringForKey:showID];
            self.from = [dict valueStringForKey:from];
            self.from_Name = [dict valueStringForKey:from_Name];
            self.to = [dict valueStringForKey:to];
            self.to_Name = [dict valueStringForKey:to_Name];
            self.title = [dict valueStringForKey:title];
            self.content = [dict valueStringForKey:content];
            self.type = [[dict valueNumberForKey:type] integerValue];
            self.appMessageType = [dict valueStringForKey:appMessageType];
            self.remark = [dict valueStringForKey:remark];
            self.statusTime = [[dict valueNumberForKey:statusTime] longLongValue];
            self.appShowID = [dict valueStringForKey:appShowID];
            self.rmShowID = [dict valueStringForKey:rmShowID];
            self.readStatus = [[dict valueNumberForKey:readStatus] integerValue];
            self.handleStatus = [[dict valueNumberForKey:handleStatus] integerValue];
            self.createTime = [[dict valueNumberForKey:createTime] longLongValue];
            self.createUser = [dict valueStringForKey:createUser];
            self.createUserName = [dict valueStringForKey:createUserName];
        }
    }
    return self;
}
@end
