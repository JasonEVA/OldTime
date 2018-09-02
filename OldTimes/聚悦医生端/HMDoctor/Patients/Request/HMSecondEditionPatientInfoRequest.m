//
//  HMSecondEditionPatientInfoRequest.m
//  HMDoctor
//
//  Created by jasonwang on 2016/11/21.
//  Copyright © 2016年 yinquan. All rights reserved.
//

#import "HMSecondEditionPatientInfoRequest.h"
#import "HMSecondEditionPationInfoModel.h"

@implementation HMSecondEditionPatientInfoRequest
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postAdmissionService:@"getAdmission"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]]){
        _taskResult = [HMSecondEditionPationInfoModel mj_objectWithKeyValues:stepResult];
    }
}
@end
