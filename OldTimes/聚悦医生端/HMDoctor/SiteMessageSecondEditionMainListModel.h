//
//  SiteMessageSecondEditionMainListModel.h
//  HMClient
//
//  Created by jasonwang on 2016/12/28.
//  Copyright © 2016年 YinQ. All rights reserved.
//  第二版站内信 主页cell model

#import <Foundation/Foundation.h>
#import "SiteMessageLastMsgModel.h"

@interface SiteMessageSecondEditionMainListModel : NSObject
@property (nonatomic, copy) NSString *typeName;          //类型名
@property (nonatomic) NSInteger typeCount;               //未读数
@property (nonatomic, copy) NSString *typeCode;          //类型码
@property (nonatomic) NSInteger status;               //提醒状态       // 1为提醒 0为不提醒
@property (nonatomic, strong) SiteMessageLastMsgModel *lastMsg; //最后一条消息体
@end
