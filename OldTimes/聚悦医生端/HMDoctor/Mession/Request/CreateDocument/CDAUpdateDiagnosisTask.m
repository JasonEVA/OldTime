//
//  CDAUpdateDiagnosisTask.m
//  HMDoctor
//
//  Created by yinqaun on 16/8/26.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "CDAUpdateDiagnosisTask.h"

@implementation CDAUpdateDiagnosisTask

- (NSString*) postUrl
{
    //    NSString* postUrl = [ClientHelper postArchiveTemplateServiceUrl:@"getHealthTemplateType"];
    NSString* postUrl = [ClientHelper postArchiveTemplateServiceUrl:@"updateDiagnosis"];
    return postUrl;
}

@end

@implementation CDASendAssessmentToDoctorTask

- (NSString*) postUrl
{
    //    NSString* postUrl = [ClientHelper postArchiveTemplateServiceUrl:@"getHealthTemplateType"];
    NSString* postUrl = [ClientHelper postArchiveTemplateServiceUrl:@"sendAssessmentReport2Doctor"];
    return postUrl;
}

@end

@implementation CDABuildAssessmentReportTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postArchiveTemplateServiceUrl:@"buildAssessmentReport"];
    return postUrl;
}

@end
