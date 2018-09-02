//
//  AdmissionAssessSummaryModel.m
//  HMDoctor
//
//  Created by lkl on 2017/3/20.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "AdmissionAssessSummaryModel.h"

@implementation BfzResultListModel

@end

@implementation AdmissionAssessSummaryModel

+ (NSDictionary *)objectClassInArray{
    return @{
             @"bfzResultList" : @"BfzResultListModel",
             @"jbResultList" : @"HMThirdEditionPatitentDiagnoseModel",
             };
}

@end
