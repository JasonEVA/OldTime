//
//  NewPatientListInfoModel.m
//  HMDoctor
//
//  Created by Andrew Shen on 2016/12/8.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "NewPatientListInfoModel.h"
#import "PatientInfo.h"

@implementation NewPatientListInfoModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if (property.type.typeClass == [NSString class]) {
        if (oldValue == nil || oldValue == [NSNull null] || oldValue == NULL) {
            return @"";
        }
        
        if ([oldValue isEqualToString:@"(null)"]) {
            return @"";
        }
    }
    
    return oldValue;
}

- (PatientInfo *)convertToPatientInfo {
    PatientInfo *info = [PatientInfo new];
    info.userId = self.userId;
    info.userName = self.userName;
    info.imgUrl = self.avatar;
    info.age = self.age;
    info.sex = self.sex;
    info.userTestDatas = self.userTestDatas;
    info.teamId = self.teamId.integerValue;
    info.paymentType = self.paymentType;
    info.illDiagnose = self.illDiagnose;
    info.imGroupId = self.imGroupId;
    info.diseaseTitle = self.diseaseTitle;
    return info;
}

@end
