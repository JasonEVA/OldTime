//
//  NewSiteMessageAppointmentRemindModel.h
//  HMClient
//
//  Created by jasonwang on 2016/11/2.
//  Copyright © 2016年 YinQ. All rights reserved.
//  约诊提醒model

#import <Foundation/Foundation.h>

@interface NewSiteMessageAppointmentRemindModel : NSObject
@property (nonatomic, copy) NSString *msgTitle;
@property (nonatomic, copy) NSString *routerUrl;
@property (nonatomic, copy) NSString *staffName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic) NSInteger appointId;
@property (nonatomic) NSInteger staffId;

@end

//{"msgTitle":"申请已通过","routerUrl":"jyhmclient://appointment/appointDetail?appointId=869","staffId":3023507,"staffName":"何娟（主治）","userId":"10645","type":"appointAgree","appointId":869,"msg":"【JasonWang】您好！您的约诊申请已通过，请在2017-02-14 11:41:00到浙江省中医院地点就诊"}
