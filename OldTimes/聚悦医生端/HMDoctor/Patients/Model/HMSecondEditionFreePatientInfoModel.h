//
//  HMSecondEditionFreePatientInfoModel.h
//  HMDoctor
//
//  Created by jasonwang on 2016/11/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//  第二版患者基本信息页model（免费患者）

#import <Foundation/Foundation.h>
#import "HMSecondEditionFreePatientInfoDrugModel.h"
#import "HMSecondEditionFreePatientInfoDiagnosesModel.h"
#import "HMSecondEditionFreeCheckGroupModel.h"

@interface HMSecondEditionFreePatientInfoModel : NSObject
@property (nonatomic, copy) NSArray <HMSecondEditionFreePatientInfoDrugModel* > *admissionDrugList;          //用药列表
@property (nonatomic, copy) NSArray <HMSecondEditionFreeCheckGroupModel* > *admissionCheckList;        //辅助检查
@property (nonatomic, copy) NSArray <HMSecondEditionFreePatientInfoDiagnosesModel* > *admissionDiagnosesList;     //诊断

@property (nonatomic, copy) NSString *symptoms;   //主诉
@property (nonatomic, copy) NSString *hpi;        //现病史


@end
