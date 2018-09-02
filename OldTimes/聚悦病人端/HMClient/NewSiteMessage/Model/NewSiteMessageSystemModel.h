//
//  NewSiteMessageSystemModel.h
//  HMClient
//
//  Created by jasonwang on 2016/11/2.
//  Copyright © 2016年 YinQ. All rights reserved.
//  站内信系统消息model

#import <Foundation/Foundation.h>

@interface NewSiteMessageSystemModel : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *msg;   //消息体
@property (nonatomic, copy) NSString *msgTitle;   //标题
@end
