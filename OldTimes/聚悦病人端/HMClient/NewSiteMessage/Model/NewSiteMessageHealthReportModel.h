//
//  NewSiteMessageHealthReportModel.h
//  HMClient
//
//  Created by jasonwang on 2017/1/19.
//  Copyright © 2017年 YinQ. All rights reserved.
//  站内信 健康报告model

#import <Foundation/Foundation.h>

@interface NewSiteMessageHealthReportModel : NSObject
@property (nonatomic, copy) NSString *msgTitle; //消息标题
@property (nonatomic, copy) NSString *type;  //类型
@property (nonatomic, copy) NSString *msg;   //消息体
@property (nonatomic, copy) NSString *healthyReportId;   //健康报告id
@property (nonatomic, copy) NSString *jumpUrl; //饮食记录、饮食报告 URL
@end
