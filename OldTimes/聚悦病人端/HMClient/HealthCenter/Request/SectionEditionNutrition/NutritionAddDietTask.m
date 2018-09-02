//
//  NutritionAddDietTask.m
//  HMClient
//
//  Created by lkl on 2017/8/16.
//  Copyright © 2017年 YinQ. All rights reserved.
//

#import "NutritionAddDietTask.h"
#import "NutritionDietRecord.h"

@implementation NutritionAddDietTask


- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postCommonHealthyPlanServiceUrl:@"addUserDietRecord4New"];
    return postUrl;
}

@end


@implementation NutritionGetDietBeanTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postCommonHealthyPlanServiceUrl:@"getUserDietBean"];
    return postUrl;
}

- (void) makeTaskResult
{
    id stepResult = currentStep.stepResult;
    if([stepResult isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dicResp = (NSDictionary*) stepResult;
        NutritionDietBeanModel *beanModel = [NutritionDietBeanModel mj_objectWithKeyValues:dicResp];
        _taskResult = beanModel;
        return;
    }
//    _taskErrorMessage = @"接口数据访问失败。";
//    _taskError = StepError_NetwordDataError;
}
@end
