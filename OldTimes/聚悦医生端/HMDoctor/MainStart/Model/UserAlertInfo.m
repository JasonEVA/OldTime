//
//  UserAlertInfo.m
//  HMDoctor
//
//  Created by yinqaun on 16/6/2.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "UserAlertInfo.h"
#import "PatientInfo.h"

@implementation UseralertDets

@end

@implementation UserAlertInfo

- (NSString*) uploadTimeString
{
    NSDate* detectDate = [NSDate dateWithString:self.uploadTime formatString:@"yyyy-MM-dd HH:mm:ss"];
    NSString* timeStr = [detectDate formattedDateWithFormat:@"HH:mm"];
    //[lbDetectTime setText:timeStr];
    
    NSString* dateStr = [detectDate formattedDateWithFormat:@"yyyy-MM-dd "];
    if ([detectDate isToday])
    {
        dateStr = @"今天 ";
    }
    if ([detectDate isYesterday])
    {
        dateStr = @"昨天 ";
    }
    
    NSString* detectTime = [dateStr stringByAppendingString:timeStr];
    return detectTime;
}

- (PatientInfo *)convertToPatientInfo {
    PatientInfo *info = [PatientInfo new];
    info.userId = self.userId;
    info.userName = self.userName;
    info.imgUrl = self.imgUrl;
    info.age = self.age;
    info.sex = self.sex;
    info.illDiagnose = self.illDiagnose;
    info.testResulId = self.testResulId;
    info.illDiagnose = self.illDiagnose;
    //预警处理提示框
    info.testName = self.testName;
    info.uploadTime = self.uploadTime;
    info.testValue = self.dataDets.testValue;
    info.doStatus = self.doStatus;
    info.kpiCode = self.kpiCode;
    return info;
}

@end

@implementation UserWarningRecord

@end

@implementation ArchivesDetailModel

@end

@implementation UserWarningDetInfo

@end

