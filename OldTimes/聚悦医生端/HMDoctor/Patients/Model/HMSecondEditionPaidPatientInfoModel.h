//
//  HMSecondEditionPaidPatientInfoModel.h
//  HMDoctor
//
//  Created by jasonwang on 2016/11/23.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMSecondEditionFreePatientInfoDiagnosesModel.h"
#import "HMSecondEditionPaidPatientReportModel.h"

@interface HMSecondEditionPaidPatientInfoModel : NSObject
@property (nonatomic, copy) NSArray <HMSecondEditionFreePatientInfoDiagnosesModel* > *admissionDiagnosesList;//诊断
@property (nonatomic, copy) NSArray <HMSecondEditionPaidPatientReportModel* > *reports;//报告
@end
