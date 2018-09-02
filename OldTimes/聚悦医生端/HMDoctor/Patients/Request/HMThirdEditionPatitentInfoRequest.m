//
//  HMThirdEditionPatitentInfoRequest.m
//  HMDoctor
//
//  Created by jasonwang on 2017/1/6.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMThirdEditionPatitentInfoRequest.h"
#import "HMThirdEditionPatitentInfoModel.h"

@implementation HMThirdEditionPatitentInfoRequest
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postAdmissionService:@"getUserAdmission"];
    return postUrl;
}

- (void)makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if ([stepResult isKindOfClass:[NSDictionary class]]){
        _taskResult = [HMThirdEditionPatitentInfoModel mj_objectWithKeyValues:stepResult];
    }
}
@end
