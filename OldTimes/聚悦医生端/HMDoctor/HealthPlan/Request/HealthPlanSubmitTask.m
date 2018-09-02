//
//  HealthPlanSubmitTask.m
//  HMDoctor
//
//  Created by yinquan on 2017/9/6.
//  Copyright © 2017年 yinquan. All rights reserved.
//

#import "HealthPlanSubmitTask.h"

@implementation HealthPlanSubmitTask

- (NSString*) postUrl
{
    NSString* postUrl = [ClientHelper postHealthyPlanServiceServiceUrl:@"updateUserHealthyPlanDets"];
    return postUrl;
}

@end
