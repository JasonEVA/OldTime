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
