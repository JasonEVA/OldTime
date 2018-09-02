//
//  ApplyMessageModel.h
//  launcher
//
//  Created by Conan Ma on 15/9/16.
//  Copyright (c) 2015年 William Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplyMessageModel : NSObject

@property (nonatomic, strong) NSString *showID;              //消息的ShowID
@property (nonatomic, strong) NSString *from;                //发送人
@property (nonatomic, strong) NSString *from_Name;           //发送人姓名
@property (nonatomic, strong) NSString *to;                  //接收人
@property (nonatomic, strong) NSString *to_Name;             //接收人姓名
@property (nonatomic, strong) NSString *title;               //标题
@property (nonatomic, strong) NSString *content;             //内容
@property (nonatomic) NSInteger type;                        //消息类型，1代表业务消息，0代表系统消息
@property (nonatomic, strong) NSString *appMessageType;      //消息应用类型，暂时有MEETING-会议，EVENT-事件，APPROVE-审批，CC-抄送，SEND-发出
@property (nonatomic, strong) NSString *remark;              //备注
@property (nonatomic) long long statusTime;                  //更改时间
@property (nonatomic, strong) NSString *appShowID;           //应用ShowID
@property (nonatomic, strong) NSString *rmShowID;            //关联主键
@property (nonatomic) NSInteger readStatus;                  //是否已读，1代表已读，0代表未读
@property (nonatomic) NSInteger handleStatus;                //是否已处理，1代表已处理，0代表未处理
@property (nonatomic) long long createTime;                  //创建时间
@property (nonatomic, strong) NSString *createUser;          //创建人
@property (nonatomic, strong) NSString *createUserName;      //创建人姓名

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
