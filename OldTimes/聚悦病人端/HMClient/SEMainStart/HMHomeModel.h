//
//  HMHomeModel.h
//  HMClient
//
//  Created by JasonWang on 2017/5/3.
//  Copyright © 2017年 YinQ. All rights reserved.
//  第二版主页model

#import <Foundation/Foundation.h>
#import "TeamInfo.h"

@class UserCareInfo;
@class MainStartHealthTargetModel;
@class DoctorGreetingInfo;
@class PlanMessionListItem;
@class HMAdsModel;

@interface HMHomeModel : NSObject
@property (nonatomic, strong) TeamDetail *orgTeam;  //医生团队信息
@property (nonatomic, copy) NSArray <UserCareInfo *>*systemUserCares;// 系统关怀信息（XXX竭诚为您服务）
@property (nonatomic, copy) NSArray <DoctorGreetingInfo *>*doctorCares;// 医生关怀信息
@property (nonatomic, copy) NSArray <PlanMessionListItem *>*healthyTask;  //今日任务
@property (nonatomic, copy) NSDictionary *mcClassList;  // 健康课堂
@property (nonatomic, copy) NSArray<MainStartHealthTargetModel *> *userTestTarget;  // 监测仪表盘数据
@property (nonatomic, copy) NSDictionary *ads;        //banner广告
@property (nonatomic, copy) NSDictionary *orderInfo;  // 用户服务状态

@property (nonatomic, copy) NSArray<HMAdsModel *> *adsModelArr;     // 自己加的，方便使用
@end
