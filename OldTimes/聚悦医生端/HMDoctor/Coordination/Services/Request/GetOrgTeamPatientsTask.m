//
//  GetOrgTeamPatientsTask.m
//  HMDoctor
//
//  Created by Andrew Shen on 16/6/7.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "GetOrgTeamPatientsTask.h"
#import "PatientInfo.h"

@implementation GetOrgTeamPatientsTask



- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postOrgTeamServiceUrl:@"getOrgTeamPatientByStaffId"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSArray class]])
    {
        NSArray *array = [PatientGroupInfo mj_objectArrayWithKeyValuesArray:stepResult];
        _taskResult = array;
    }
}

@end
