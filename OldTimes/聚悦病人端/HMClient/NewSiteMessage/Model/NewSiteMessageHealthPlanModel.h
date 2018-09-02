//
//  NewSiteMessageHealthPlanModel.h
//  HMClient
//
//  Created by jasonwang on 2016/12/29.
//  Copyright © 2016年 YinQ. All rights reserved.
//  站内信 健康计划model

#import <Foundation/Foundation.h>

@interface NewSiteMessageHealthPlanModel : NSObject
@property (nonatomic, copy) NSString *msgTitle;
@property (nonatomic, copy) NSString *healthyPlanId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *healthPlanName;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *endtime;
@property (nonatomic, copy) NSString *begintime;

@end
