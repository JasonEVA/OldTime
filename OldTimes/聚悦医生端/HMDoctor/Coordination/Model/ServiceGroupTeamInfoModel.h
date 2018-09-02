//
//  ServiceGroupTeamInfoModel.h
//  HMDoctor
//
//  Created by Andrew Shen on 16/6/6.
//  Copyright © 2016年 yinquan. All rights reserved.
//  服务器团队成员model

#import <Foundation/Foundation.h>

@class ServiceGroupMemberModel;

@interface ServiceGroupTeamInfoModel : NSObject

@property (nonatomic, copy)  NSString  *depName;
@property (nonatomic, copy)  NSString  *imgUrl;
@property (nonatomic, assign)  NSInteger  orgId;
@property (nonatomic, copy)  NSString  *orgName;
@property (nonatomic, copy)  NSArray<ServiceGroupMemberModel *>  *orgTeamDet;
@property (nonatomic, copy)  NSArray  *services;
@property (nonatomic, copy)  NSString  *staffTypeName;
@property (nonatomic, copy)  NSString  *status;
@property (nonatomic, copy)  NSString  *teamCode;
@property (nonatomic, copy)  NSString  *teamDesc;
@property (nonatomic, assign)  NSInteger  teamId;
@property (nonatomic, copy)  NSString  *teamName;
@property (nonatomic, assign)  NSInteger  teamStaffId;
@property (nonatomic, copy)  NSString  *teamStaffName;
@property (nonatomic, assign)  NSInteger  teamUserId;
@property (nonatomic, assign)  NSInteger  userId;

@property (nonatomic, copy)  NSString  *isOnline;
@property (nonatomic, copy)  NSString  *isProvider;
@property (nonatomic, copy)  NSString  *isRecommend;
@property (nonatomic, copy)  NSString  *isSaler;
@property (nonatomic, copy)  NSString  *opTime;
@property (nonatomic, assign)  NSInteger  opeator;

@end
