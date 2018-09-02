//
//  HMSecondEditionFreePatientInfoModel.m
//  HMDoctor
//
//  Created by jasonwang on 2016/11/17.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMSecondEditionFreePatientInfoModel.h"
#import "MJExtension.h"

@implementation HMSecondEditionFreePatientInfoModel

+ (NSDictionary *)objectClassInArray
{
    return @{@"admissionDrugList" : [HMSecondEditionFreePatientInfoDrugModel class],
             @"admissionCheckList" : [HMSecondEditionFreeCheckGroupModel class],
             @"admissionDiagnosesList" : [HMSecondEditionFreePatientInfoDiagnosesModel class]};
    
}

@end
