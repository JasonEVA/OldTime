//
//  HMSecondEditionPaidPatientInfoModel.m
//  HMDoctor
//
//  Created by jasonwang on 2016/11/23.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMSecondEditionPaidPatientInfoModel.h"
#import "MJExtension.h"

@implementation HMSecondEditionPaidPatientInfoModel

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"admissionDiagnosesList" : [HMSecondEditionFreePatientInfoDiagnosesModel class],
             @"reports":[HMSecondEditionPaidPatientReportModel class]};
    
}
@end
