//
//  HMFindAllPresentUserServiceRequest.m
//  HMDoctor
//
//  Created by jasonwang on 2017/10/16.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HMFindAllPresentUserServiceRequest.h"
#import "HMPresentIMModel.h"

@implementation HMFindAllPresentUserServiceRequest
- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postUserServiceUrl:@"findAllPresentUserService"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult[@"list"];
    
    if ([stepResult isKindOfClass:[NSArray class]])
    {
                NSArray *array = [HMPresentIMModel mj_objectArrayWithKeyValuesArray:stepResult];
                _taskResult = array;
                return;
    }
    //    _taskErrorMessage = @"接口数据访问失败。";
        _taskError = StepError_NetwordDataError;
}
@end
