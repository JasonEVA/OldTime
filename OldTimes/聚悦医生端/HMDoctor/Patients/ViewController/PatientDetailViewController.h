//
//  PatientDetailViewController.h
//  HMDoctor
//
//  Created by yinqaun on 16/5/19.
//  Copyright © 2016年 yinquan. All rights reserved.
//  患者信息聊天详情界面(自2.12版本开始废弃)

#import "HMBasePageViewController.h"

typedef NS_ENUM(NSUInteger, PatientDetailSegmentedIndex) {
    PatientDetailSegmentedIndexBaseInfo,    // 基础信息
    PatientDetailSegmentedIndexChatMessage, // 会话消息
    PatientDetailSegmentedIndexEMR, // 电子病历
    PatientDetailSegmentedIndexHealthPlan,  //健康计划
};


@class ContactDetailModel,PatientInfo,HealthPlanMessionInfo;

@interface PatientDetailViewController : HMBasePageViewController

@property (nonatomic, assign) BOOL formulatePlan;       //制定计划

@property (nonatomic, assign) PatientDetailSegmentedIndex segmentedIndex;

- (instancetype)initWithContactDetailModel:(ContactDetailModel *)model;
- (instancetype)initWithPatientInfo:(PatientInfo *)patientInfo;

//预警、随访、查房、健康计划、约诊跳转
- (instancetype)initWithJumpInfo:(id)jumpInfo;

@end
