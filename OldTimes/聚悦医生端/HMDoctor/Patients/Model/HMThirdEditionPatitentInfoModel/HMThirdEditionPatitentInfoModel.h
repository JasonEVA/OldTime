//
//  HMThirdEditionPatitentInfoModel.h
//  HMDoctor
//
//  Created by jasonwang on 2017/1/6.
//  Copyright © 2017年 yinquan. All rights reserved.
//  第三版患者信息model

#import <Foundation/Foundation.h>
#import "HMThirdEditionPatitentDiagnoseModel.h"
#import "HMThirdEditionPatitentBaseInfoModel.h"
#import "HMThirdEditionPatitentHealthRiskModel.h"
#import "HMRecentMedicalModel.h"

@interface HMThirdEditionPatitentInfoModel : NSObject
@property (nonatomic, copy) NSArray<HMThirdEditionPatitentHealthRiskModel *> *assessList;      //健康风险
@property (nonatomic, copy) NSArray<HMThirdEditionPatitentDiagnoseModel *> *userIDC;         //诊断
@property (nonatomic, strong) HMThirdEditionPatitentBaseInfoModel *userInfo;
                     //基本信息
@property (nonatomic, strong) HMThirdEditionPatitentArchiveInfoModel *userArchiveInfo; //新增信息

@property (nonatomic, copy) NSArray<HMRecentMedicalModel *> *recentDugs;
                      //近期用药

@property (nonatomic) NSInteger payment;      //payment 1：免费 2：收费
@property (nonatomic) NSInteger admissionStatus;         //筛查记录状态；0:未建档;1:录入中;2:已完成;3:已删除
@property (nonatomic) NSInteger hasAdmission;         //是否有筛查记录；0:无;1:有;

@property (nonatomic, copy) NSString *admissionAssessAble;  //是否可以查看入院记录,N不可以
@property (nonatomic, copy) NSString *screeningResultPage;  //是否可以查看筛查表,N不可以
@property (nonatomic, copy) NSString *admissionId;       //查看筛查表需要传给H5

//服务信息
@property (nonatomic, copy) NSString *serviceEndDate;
@property (nonatomic, copy) NSString *serviceMoney;
@property (nonatomic, copy) NSString *serviceName;
@property (nonatomic, copy) NSString *teamName;
@end
