//
//  UserByImGroupIdTask.m
//  HMDoctor
//
//  Created by yinqaun on 16/6/29.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "UserByImGroupIdTask.h"
#import "PatientInfo.h"

@implementation UserByImGroupIdTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postOrgTeamServiceUrl:@"getUserByImGroupId"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    
    if ([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        
        PatientInfo* patient = [[PatientInfo alloc]init];
        NSString* sexStr = [dicResp valueForKey:@"SEX"];
        if (sexStr && [sexStr isKindOfClass:[NSString class]])
        {
            [patient setSex:sexStr];
        }
        
        NSString* nameStr = [dicResp valueForKey:@"USER_NAME"];
        if (nameStr && [nameStr isKindOfClass:[NSString class]])
        {
            [patient setUserName:nameStr];
        }
        
        NSNumber* numAge = [dicResp valueForKey:@"AGE"];
        if (numAge && [numAge isKindOfClass:[NSNumber class]])
        {
            [patient setAge:numAge.integerValue];
        }
        
        NSNumber* numUserId = [dicResp valueForKey:@"USER_ID"];
        if (numUserId && [numUserId isKindOfClass:[NSNumber class]])
        {
            [patient setUserId:numUserId.integerValue];
        }
        NSString* illDiagnose = [dicResp valueForKey:@"ILL_DIAGNOSE"];
        if (illDiagnose && [illDiagnose isKindOfClass:[NSString class]])
        {
            patient.illDiagnose = illDiagnose;
        }
        NSString* diseaseTitle = [dicResp valueForKey:@"diseaseTitle"];
        if (diseaseTitle && [diseaseTitle isKindOfClass:[NSString class]])
        {
            patient.diseaseTitle = diseaseTitle;
        }
        
        _taskResult = patient;
        return;
    }
    _taskError = StepError_NetwordDataError;
    _taskErrorMessage = @"服务器数据访问失败。";
    
}

@end
